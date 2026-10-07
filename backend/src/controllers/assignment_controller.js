const { pool } = require("../config/db");

const assignPatientToProvider = async (req, res) => {
  try {
    const { providerId, patientId } = req.body;

    // 1. Validate required fields
    if (!providerId || !patientId) {
      return res.status(400).json({
        success: false,
        message: "Provider ID and patient ID are required",
      });
    }

    // 2. Check provider
    const providerResult = await pool.query(
      `SELECT user_id, role
       FROM users
       WHERE user_id = $1`,
      [providerId]
    );

    if (providerResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Provider not found",
      });
    }

    if (providerResult.rows[0].role !== "provider") {
      return res.status(400).json({
        success: false,
        message: "Selected user is not a provider",
      });
    }

    // 3. Check patient
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

    if (patientResult.rows[0].role !== "patient") {
      return res.status(400).json({
        success: false,
        message: "Selected user is not a patient",
      });
    }

    // 4. Create assignment
    const result = await pool.query(
      `INSERT INTO provider_patients
       (provider_id, patient_id)
       VALUES ($1, $2)
       RETURNING *`,
      [providerId, patientId]
    );

    return res.status(201).json({
      success: true,
      message: "Patient assigned to provider successfully",
      assignment: result.rows[0],
    });

  } catch (error) {
    console.error("Assign patient error:", error);

    // Duplicate assignment
    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        message: "Patient is already assigned to this provider",
      });
    }

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  assignPatientToProvider,
};