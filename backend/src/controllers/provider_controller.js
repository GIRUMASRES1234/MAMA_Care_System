const { pool } = require("../config/db");

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

module.exports = {
  getAssignedPatients,
};