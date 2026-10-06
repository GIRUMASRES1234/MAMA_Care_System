
const { pool } = require("../config/db");

const createPregnancyProfile = async (req, res) => {
  try {
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

    // Step 1: Find the user
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

    // Step 2: Confirm the user is a patient
    if (patientResult.rows[0].role !== "patient") {
      return res.status(400).json({
        success: false,
        message: "The selected user is not a patient",
      });
    }

    // Step 3: Calculate pregnancy week from LMP
    let pregnancyWeek = null;

    if (lmp) {
      const lmpDate = new Date(`${lmp}T00:00:00Z`);
      const today = new Date();
      today.setUTCHours(0, 0, 0, 0);

      if (
        Number.isNaN(lmpDate.getTime()) ||
        lmpDate > today
      ) {
        return res.status(400).json({
          success: false,
          message: "Invalid last menstrual period date",
        });
      }

      pregnancyWeek = Math.floor(
        (today.getTime() - lmpDate.getTime()) /
        (7 * 24 * 60 * 60 * 1000)
      );
    }

    // Step 4: Check for an existing profile
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

    // Step 5: Save the profile
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

    // Handle duplicate profiles safely
    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        message: "Pregnancy profile already exists",
      });
    }

    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  createPregnancyProfile,
};