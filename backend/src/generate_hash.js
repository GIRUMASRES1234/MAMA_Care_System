const bcrypt = require("bcryptjs");

const password = "YOUR_ACTUAL_PROVIDER_PASSWORD";

bcrypt.hash(password, 10)
  .then((hash) => {
    console.log(hash);
  });