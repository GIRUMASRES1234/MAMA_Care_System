const express = require("express");

const {
  createProvider,
} = require("../controllers/admin_controller");

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

module.exports = router;