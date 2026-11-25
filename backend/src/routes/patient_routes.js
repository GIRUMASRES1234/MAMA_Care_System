const express = require("express");

const {
  authenticateToken,
  authorizeRoles,
} = require("../middleware/auth_middleware");

const {
  getMyPregnancyProfile,
  getMyReminders,
} = require("../controllers/patient_controller");

const {
  getMyAppointments,
} = require("../controllers/appointment_controller");

const router = express.Router();

router.get(
  "/pregnancy-profile",
  authenticateToken,
  authorizeRoles("patient"),
  getMyPregnancyProfile
);
// Get the authenticated patient's appointments
router.get(
  "/appointments",
  authenticateToken,
  authorizeRoles("patient"),
  getMyAppointments
);
router.get(
  "/reminders",
  authenticateToken,
  authorizeRoles("patient"),
  getMyReminders
);
module.exports = router;