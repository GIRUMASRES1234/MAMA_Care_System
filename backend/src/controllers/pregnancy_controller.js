const { pool } = require("../config/db");
const {
  calculatePregnancyWeek,
} = require("../utils/pregnancy_utils");
const createPregnancyProfile = async (req, res) => {
  



  try {
    // Provider ID comes from the verified JWT
    const providerId = req.user.userId;

    // Patient ID comes from the URL
    const { patientId } = req.params;

    const {
      address,
      medical_conditions,
      lmp,
      edd,
      pregnancy_history,
      emergency_contact_name,
      emergency_contact_phone,
    } = req.body;

    // -----------------------------------
    // 1. Check that the patient exists
    // -----------------------------------

    const patientResult = await pool.query(
      `SELECT user_id, role
       FROM users
       WHERE user_id = $1`,
      [patientId]
    );

    if (patientResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    // -----------------------------------
    // 2. Make sure the user is a patient
    // -----------------------------------

    if (patientResult.rows[0].role !== "patient") {
      return res.status(400).json({
        success: false,
        message: "The selected user is not a patient",
      });
    }

    // -----------------------------------
    // 3. Check provider-patient assignment
    // -----------------------------------


    const assignmentResult = await pool.query(
      `SELECT assignment_id
       FROM provider_patients
       WHERE provider_id = $1
       AND patient_id = $2`,
      [providerId, patientId]
    );

    if (assignmentResult.rows.length === 0) {
      return res.status(403).json({
        success: false,
        message: "This patient is not assigned to you",
      });
    }

    // -----------------------------------
    // 4. Check existing pregnancy profile
    // -----------------------------------

    const existingProfile = await pool.query(
      `SELECT profile_id
       FROM pregnancy_profiles
       WHERE user_id = $1`,
      [patientId]
    );

    if (existingProfile.rows.length > 0) {
      return res.status(409).json({
        success: false,
        message: "Pregnancy profile already exists",
      });
    }

    // -----------------------------------
    // 5. Create pregnancy profile
    // -----------------------------------
// Calculate pregnancy week from LMP
let pregnancyWeek = null;

if (lmp) {
  pregnancyWeek = calculatePregnancyWeek(lmp);
}
   const result = await pool.query(
  `INSERT INTO pregnancy_profiles (
    user_id,
    address,
    medical_conditions,
    lmp,
    edd,
    pregnancy_week,
    pregnancy_history,
    emergency_contact_name,
    emergency_contact_phone
  )
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
  RETURNING *`,
  [
    patientId,
    address || null,
    medical_conditions || null,
    lmp || null,
    edd || null,
    pregnancyWeek,
    pregnancy_history || null,
    emergency_contact_name || null,
    emergency_contact_phone || null,
  ]
);

    return res.status(201).json({
      success: true,
      message: "Pregnancy profile created successfully",
      profile: result.rows[0],
    });

  } catch (error) {
    console.error("Create pregnancy profile error:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

const updatePregnancyProfile = async (req, res) => {
  try {
    const providerId = req.user.userId;
    const { patientId } = req.params;

    const allowedFields = [
      "address",
      "medical_conditions",
      "lmp",
      "edd",
      "pregnancy_history",
      "emergency_contact_name",
      "emergency_contact_phone",
    ];

    // Keep only fields the provider is allowed to update.
    const updates = Object.entries(req.body).filter(
      ([key]) => allowedFields.includes(key)
    );

    if (updates.length === 0) {
      return res.status(400).json({
        success: false,
        message: "No valid fields provided for update",
      });
    }

    // Validate supplied dates before sending them to PostgreSQL.
    const datePattern = /^\d{4}-\d{2}-\d{2}$/;

    const dateToUtc = (value) => {
      if (typeof value !== "string" ||
          !datePattern.test(value)) {
        return null;
      }

      const date = new Date(`${value}T00:00:00Z`);

      if (
        Number.isNaN(date.getTime()) ||
        date.toISOString().slice(0, 10) !== value
      ) {
        return null;
      }

      return date;
    };

    for (const [key, value] of updates) {
      if (["lmp", "edd"].includes(key) && value !== null) {
        if (!dateToUtc(value)) {
          return res.status(400).json({
            success: false,
            message: `${key} must be a valid YYYY-MM-DD date`,
          });
        }
      }
    }

    const patientResult = await pool.query(
      `SELECT user_id
       FROM users
       WHERE user_id = $1
       AND role = 'patient'`,
      [patientId]
    );

    if (patientResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    const assignmentResult = await pool.query(
      `SELECT assignment_id
       FROM provider_patients
       WHERE provider_id = $1
       AND patient_id = $2`,
      [providerId, patientId]
    );

    if (assignmentResult.rows.length === 0) {
      return res.status(403).json({
        success: false,
        message: "This patient is not assigned to you",
      });
    }

    // Find the current profile.
    const currentResult = await pool.query(
      `SELECT profile_id, lmp, edd
       FROM pregnancy_profiles
       WHERE user_id = $1`,
      [patientId]
    );

    if (currentResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Pregnancy profile not found",
      });
    }

    const current = currentResult.rows[0];

    
const getUpdatedValue = (field) => {
  const entry = updates.find(([key]) => key === field);

  if (!entry) {
    return current[field];
  }

  const value = entry[1];

  if (["lmp", "edd"].includes(field) && value instanceof Date) {
    return value.toISOString().slice(0, 10);
  }

  return value;
};


    const newLmp = getUpdatedValue("lmp");
    const newEdd = getUpdatedValue("edd");

const lmpIsBeingUpdated = updates.some(
  ([key]) => key === "lmp"
);

const eddIsBeingUpdated = updates.some(
  ([key]) => key === "edd"
);

if (lmpIsBeingUpdated && !eddIsBeingUpdated) {
  return res.status(400).json({
    success: false,
    message: "Please provide EDD when updating LMP",
  });
}

    // Keep the stored pregnancy week in sync whenever LMP changes.
   
if (updates.some(([key]) => key === "lmp")) {
  let pregnancyWeek = null;

  try {
    if (newLmp) {
      const pregnancyData = calculatePregnancyWeek(newLmp);
      pregnancyWeek = pregnancyData.weeks;
    }
  } catch (error) {
    return res.status(400).json({
      success: false,
      message: error.message,
    });
  }

  updates.push(["pregnancy_week", pregnancyWeek]);
}


    if (
      newLmp &&
      newEdd &&
      dateToUtc(newEdd) < dateToUtc(newLmp)
    ) {
      return res.status(400).json({
        success: false,
        message: "EDD cannot be earlier than LMP",
      });
    }

    // Build SQL only from whitelisted column names.
    const setClauses = updates.map(
      ([key], index) => `${key} = $${index + 1}`
    );

    const values = updates.map(([, value]) => value);
    values.push(patientId);

    const result = await pool.query(
      `UPDATE pregnancy_profiles
       SET ${setClauses.join(", ")}
       WHERE user_id = $${values.length}
       RETURNING *`,
      values
    );

    return res.json({
      success: true,
      message: "Pregnancy profile updated successfully",
      profile: result.rows[0],
    });

  } catch (error) {
  console.error("Update pregnancy profile error:", error.message);
  console.error(error.stack);

  return res.status(500).json({
    success: false,
    message: "Server error",
  });
}
};



module.exports = {
   updatePregnancyProfile,
  createPregnancyProfile,
};
