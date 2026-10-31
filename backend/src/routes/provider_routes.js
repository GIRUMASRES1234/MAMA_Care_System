
const express = require("express");

const {
  authenticateToken,
  authorizeRoles,
} = require("../middleware/auth_middleware");
const {
  createAppointment,
  getPatientAppointments,
} = require("../controllers/appointment_controller");
const {
  createPregnancyProfile,
} = require("../controllers/pregnancy_controller");
const {
  updatePregnancyProfile,
} = require("../controllers/pregnancy_controller");
const {
  getAssignedPatients,
  getPatientPregnancyProfile,
} = require("../controllers/provider_controller");
const router = express.Router();

// Provider dashboard
router.get(
  "/dashboard",
  authenticateToken,
  authorizeRoles("provider"),
  (req, res) => {
    res.json({
      success: true,
      message: "Welcome to the provider dashboard",
      user: req.user,
    });
  }
);

// Create a patient's pregnancy profile
router.post(
  "/patients/:patientId/pregnancy-profile",
  authenticateToken,
  authorizeRoles("provider"),
  createPregnancyProfile,
  
);
router.get(
  "/patients",
  authenticateToken,
  authorizeRoles("provider"),
  getAssignedPatients
);
router.patch(
  "/patients/:patientId/pregnancy-profile",
  authenticateToken,
  authorizeRoles("provider"),
  updatePregnancyProfile
);
router.get(
  "/patients/:patientId/pregnancy-profile",
  authenticateToken,
  authorizeRoles("provider"),
  getPatientPregnancyProfile
);
// Schedule an appointment for an assigned patient
router.post(
  "/patients/:patientId/appointments",
  authenticateToken,
  authorizeRoles("provider"),
  createAppointment
);
// Get appointments for an assigned patient
router.get(
  "/patients/:patientId/appointments",
  authenticateToken,
  authorizeRoles("provider"),
  getPatientAppointments
);
module.exports = router;