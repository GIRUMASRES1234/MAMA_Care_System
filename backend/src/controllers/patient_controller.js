const { pool } = require("../config/db");

const getMyPregnancyProfile = async (req, res) => {
  try {
    // Get the authenticated user's ID from the JWT
    const userId = req.user.userId;

    const result = await pool.query(
      `SELECT
        profile_id,
        user_id,
        address,
        medical_conditions,
        lmp,
        edd,
        pregnancy_week,
        pregnancy_history,
        emergency_contact_name,
        emergency_contact_phone
       FROM pregnancy_profiles
       WHERE user_id = $1`,
      [userId]
    );

    // No profile found
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Pregnancy profile not found",
      });
    }

    return res.json({
      success: true,
      message: "Pregnancy profile retrieved successfully",
      profile: result.rows[0],
    });

  } catch (error) {
    console.error("Get pregnancy profile error:", error);

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  getMyPregnancyProfile,
};