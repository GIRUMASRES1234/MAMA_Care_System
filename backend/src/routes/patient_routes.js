const express = require("express");

const {
  authenticateToken,
  authorizeRoles,
} = require("../middleware/auth_middleware");

const {
  getMyPregnancyProfile,
} = require("../controllers/patient_controller");

const router = express.Router();

router.get(
  "/pregnancy-profile",
  authenticateToken,
  authorizeRoles("patient"),
  getMyPregnancyProfile
);

module.exports = router;