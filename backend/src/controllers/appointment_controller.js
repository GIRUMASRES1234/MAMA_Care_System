
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

const getPatientAppointments = async (req, res) => {
  try {
    const { patientId } = req.params;

    // 1. Verify that the patient exists
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

    // 2. Verify that the provider is assigned to this patient
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

    // 3. Retrieve appointments for this provider and patient
    const result = await pool.query(
      `SELECT appointment_id, patient_id, provider_id,
              appointment_date, reason, status, created_at
       FROM appointments
       WHERE patient_id = $1 AND provider_id = $2
       ORDER BY appointment_date ASC`,
      [patientId, req.user.userId]
    );

    return res.status(200).json({
      success: true,
      count: result.rows.length,
      appointments: result.rows,
    });
  } catch (error) {
    console.error("Get patient appointments error:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to retrieve appointments",
    });
  }
};

const updateAppointment = async (req, res) => {
  try {
    const { patientId, appointmentId } = req.params;
    const { appointment_date, status } = req.body;

    // 1. Validate that at least one field is provided
    if (appointment_date === undefined && status === undefined) {
      return res.status(400).json({
        success: false,
        message: "Provide appointment date or status to update",
      });
    }

    // 2. Validate the appointment date if provided
    let appointmentDate;

    if (appointment_date !== undefined) {
      if (!appointment_date) {
        return res.status(400).json({
          success: false,
          message: "Appointment date cannot be empty",
        });
      }

      appointmentDate = new Date(appointment_date);

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
    }

    // 3. Validate status if provided
    const allowedStatuses = [
      "scheduled",
      "completed",
      "cancelled",
    ];

    if (
      status !== undefined &&
      !allowedStatuses.includes(status)
    ) {
      return res.status(400).json({
        success: false,
        message: "Invalid appointment status",
      });
    }

    // 4. Check provider assignment
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

    // 5. Find the appointment owned by this provider
    const appointmentResult = await pool.query(
      `SELECT appointment_id, status
       FROM appointments
       WHERE appointment_id = $1
         AND patient_id = $2
         AND provider_id = $3`,
      [appointmentId, patientId, req.user.userId]
    );

    if (appointmentResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Appointment not found",
      });
    }

    const currentAppointment = appointmentResult.rows[0];

    // 6. Prevent changes to completed or cancelled appointments
    if (
      currentAppointment.status !== "scheduled" &&
      (appointment_date !== undefined || status !== undefined)
    ) {
      return res.status(400).json({
        success: false,
        message: "Completed or cancelled appointments cannot be updated",
      });
    }

    // 7. Build the update query
    const updates = [];
    const values = [];

    if (appointment_date !== undefined) {
      values.push(appointmentDate.toISOString());
      updates.push(`appointment_date = $${values.length}`);
    }

    if (status !== undefined) {
      values.push(status);
      updates.push(`status = $${values.length}`);
    }

    values.push(appointmentId, patientId, req.user.userId);

    const result = await pool.query(
      `UPDATE appointments
       SET ${updates.join(", ")}
       WHERE appointment_id = $${values.length - 2}
         AND patient_id = $${values.length - 1}
         AND provider_id = $${values.length}
       RETURNING appointment_id, patient_id, provider_id,
                 appointment_date, reason, status, created_at`,
      values
    );

    return res.status(200).json({
      success: true,
      message: "Appointment updated successfully",
      appointment: result.rows[0],
    });
  } catch (error) {
    console.error("Update appointment error:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to update appointment",
    });
  }
};

module.exports = {
  createAppointment,
  getPatientAppointments,
   updateAppointment,
};
