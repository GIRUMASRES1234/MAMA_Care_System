const bcrypt = require("bcryptjs");
const { pool } = require("../config/db");

const createProvider = async (req, res) => {
  try {
    const {
      username,
      full_name,
      phone_number,
      password,
    } = req.body;

    if (!username || !full_name || !password) {
      return res.status(400).json({
        success: false,
        message: "Required fields are missing",
      });
    }

    const existingUser = await pool.query(
      "SELECT user_id FROM users WHERE username = $1",
      [username]
    );

    if (existingUser.rows.length > 0) {
      return res.status(409).json({
        success: false,
        message: "Username already exists",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO users
       (username, full_name, phone_number, password, role)
       VALUES ($1, $2, $3, $4, 'provider')
       RETURNING user_id, username, full_name, phone_number, role, status, created_at`,
      [
        username,
        full_name,
        phone_number || null,
        hashedPassword,
      ]
    );

    res.status(201).json({
      success: true,
      message: "Provider account created successfully",
      user: result.rows[0],
    });
  } catch (error) {
    console.error("Create provider error:", error);

    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  createProvider,
};