const { pool } = require("../config/db");

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

    const result = await pool.query(
      `INSERT INTO pregnancy_profiles (
        user_id,
        address,
        medical_conditions,
        lmp,
        edd,
        pregnancy_history,
        emergency_contact_name,
        emergency_contact_phone
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *`,
      [
        patientId,
        address || null,
        medical_conditions || null,
        lmp || null,
        edd || null,
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

module.exports = {
  createPregnancyProfile,
};