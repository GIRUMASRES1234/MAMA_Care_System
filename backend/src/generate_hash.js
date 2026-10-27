const bcrypt = require("bcryptjs");

const password = "PatientPassword123DE";

bcrypt.hash(password, 10)
  .then((hash) => {
    console.log(hash);
  });