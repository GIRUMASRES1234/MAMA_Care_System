
const {
  calculatePregnancyAge,
  calculatePregnancyWeek,
} = require("./utils/pregnancy_utils");

// Test 1: A valid date in the past
const result = calculatePregnancyWeek("2026-01-01");
console.log("Pregnancy Week:", result);

// Test 2: An impossible date
try {
  calculatePregnancyWeek("2026-02-30");
} catch (error) {
  console.log("Invalid date:", error.message);
}

// Test 3: An invalid date format
try {
  calculatePregnancyWeek("01-01-2026");
} catch (error) {
  console.log("Invalid format:", error.message);
}
