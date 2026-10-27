const { pool } = require("../config/db");
const {
  calculatePregnancyWeek,
} = require("../utils/pregnancy_utils");
const getAssignedPatients = async (req, res) => {
  try { 
    // Get the authenticated provider's ID from the JWT
    const providerId = req.user.userId;
    
    const result = await pool.query(
      `SELECT
        u.user_id,
        u.username,
        u.full_name,
        u.phone_number,
        pp.assigned_at
       FROM provider_patients pp
       JOIN users u
         ON pp.patient_id = u.user_id
       WHERE pp.provider_id = $1
       ORDER BY pp.assigned_at DESC`,
      [providerId]
    );

    return res.json({
      success: true,
      message: "Assigned patients retrieved successfully",
      patients: result.rows,
    });

  } catch (error) {
    console.error("Get assigned patients error:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

const getPatientPregnancyProfile = async (req, res) => {
  try {
    // 1. Get the authenticated provider's ID
    const providerId = req.user.userId;

    // 2. Get the patient ID from the URL
    const { patientId } = req.params;

    // 3. Check that this user exists and is a patient
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

    // 4. Check whether the provider is assigned to this patient
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

    // 5. Retrieve the patient's pregnancy profile
    const profileResult = await pool.query(
      `SELECT
        profile_id,
        user_id,
        address,
        medical_conditions,
        TO_CHAR(lmp, 'YYYY-MM-DD') AS lmp,
        TO_CHAR(edd, 'YYYY-MM-DD') AS edd,
        pregnancy_week,
        pregnancy_history,
        emergency_contact_name,
        emergency_contact_phone
       FROM pregnancy_profiles
       WHERE user_id = $1`,
      [patientId]
    );

    if (profileResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Pregnancy profile not found",
      });
    }

const profile = profileResult.rows[0];

let currentPregnancyWeek = null;

if (profile.lmp) {
  
  try {
    currentPregnancyWeek = calculatePregnancyWeek(
      profile.lmp
    );
    console.log("DEBUG LMP:", profile.lmp);
console.log("DEBUG pregnancy week:", calculatePregnancyWeek(profile.lmp));
  } catch (error) {
    console.error(
      "Invalid LMP in pregnancy profile:",
      error.message
    );

    return res.status(422).json({
      success: false,
      message:
        "The recorded LMP date is invalid. Please verify the pregnancy profile.",
    });
  }
}


return res.json({
  success: true,
  message: "Pregnancy profile retrieved successfully",
  profile: {
    ...profile,
    pregnancy_week: currentPregnancyWeek?.weeks ?? null,
pregnancy_days: currentPregnancyWeek?.days ?? null,
  },
});
  

  } catch (error) {
    console.error(
      "Get patient pregnancy profile error:",
      error
    );

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  getAssignedPatients,
  getPatientPregnancyProfile,
};
