const bcrypt = require("bcryptjs");

const password = "PatientPassword123DDD";

bcrypt.hash(password, 10)
  .then((hash) => {
    console.log(hash);
  });