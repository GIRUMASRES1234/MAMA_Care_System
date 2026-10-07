const express = require("express");

const {
  createProvider,
} = require("../controllers/admin_controller");

const {
  assignPatientToProvider,
} = require("../controllers/assignment_controller");

const {
  authenticateToken,
  authorizeRoles,
} = require("../middleware/auth_middleware");

const router = express.Router();

router.post(
  "/providers",
  authenticateToken,
  authorizeRoles("admin"),
  createProvider
);

router.post(
  "/assign-patient",
  authenticateToken,
  authorizeRoles("admin"),
  assignPatientToProvider
);

module.exports = router;