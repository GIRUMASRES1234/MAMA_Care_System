const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/auth_routes");
const providerRoutes = require("./routes/provider_routes");
const adminRoutes = require("./routes/admin_routes");
const patientRoutes = require("./routes/patient_routes");
const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/provider", providerRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/patient", patientRoutes);
app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "MamaCare API is running",
  });
});

module.exports = app;