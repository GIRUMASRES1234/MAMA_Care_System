
const express = require("express");

const {
  authenticateToken,
  authorizeRoles,
} = require("../middleware/auth_middleware");

const {
  createPregnancyProfile,
} = require("../controllers/pregnancy_controller");
const {
  getAssignedPatients,
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
  createPregnancyProfile
);
router.get(
  "/patients",
  authenticateToken,
  authorizeRoles("provider"),
  getAssignedPatients
);
module.exports = router;