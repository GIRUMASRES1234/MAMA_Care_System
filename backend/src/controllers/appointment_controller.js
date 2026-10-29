
const { pool } = require("../config/db");

const createAppointment = async (req, res) => {
  try {
    const { patientId } = req.params;
    const { appointment_date, reason } = req.body;

    // 1. Validate required input
    if (!appointment_date) {
      return res.status(400).json({
        success: false,
        message: "Appointment date is required",
      });
    }

    // 2. Validate the appointment date
    const appointmentDate = new Date(appointment_date);

    if (Number.isNaN(appointmentDate.getTime())) {
      return res.status(400).json({
        success: false,
        message: "Please provide a valid appointment date",
      });
    }

    if (appointmentDate <= new Date()) {
      return res.status(400).json({
        success: false,
        message: "Appointment date must be in the future",
      });
    }

    // 3. Check that the patient exists and has the patient role
    const patientResult = await pool.query(
      `SELECT user_id
       FROM users
       WHERE user_id = $1 AND role = 'patient'`,
      [patientId]
    );

    if (patientResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    // 4. Confirm that this provider is assigned to the patient
    const assignmentResult = await pool.query(
      `SELECT 1
       FROM provider_patients
       WHERE provider_id = $1 AND patient_id = $2`,
      [req.user.userId, patientId]
    );

    if (assignmentResult.rows.length === 0) {
      return res.status(403).json({
        success: false,
        message: "You are not assigned to this patient",
      });
    }

    // 5. Save the appointment
    const result = await pool.query(
      `INSERT INTO appointments
         (patient_id, provider_id, appointment_date, reason)
       VALUES ($1, $2, $3, $4)
       RETURNING appointment_id, patient_id, provider_id,
                 appointment_date, reason, status, created_at`,
      [
        patientId,
        req.user.userId,
        appointmentDate.toISOString(),
        reason || null,
      ]
    );

    return res.status(201).json({
      success: true,
      message: "Appointment scheduled successfully",
      appointment: result.rows[0],
    });
  } catch (error) {
    console.error("Create appointment error:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to schedule appointment",
    });
  }
};

module.exports = { createAppointment };
