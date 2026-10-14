
const calculatePregnancyAge = (lmp) => {
  if (!lmp) {
    return null;
  }

  // Require a date in YYYY-MM-DD format.
  if (!/^\d{4}-\d{2}-\d{2}$/.test(lmp)) {
    throw new Error("LMP must use YYYY-MM-DD format");
  }

  const lmpDate = new Date(`${lmp}T00:00:00Z`);

  // Reject invalid calendar dates.
  if (
    Number.isNaN(lmpDate.getTime()) ||
    lmpDate.toISOString().slice(0, 10) !== lmp
  ) {
    throw new Error("LMP is not a valid date");
  }

  const today = new Date();
  const todayUtc = Date.UTC(
    today.getUTCFullYear(),
    today.getUTCMonth(),
    today.getUTCDate()
  );

  const daysSinceLmp = Math.floor(
    (todayUtc - lmpDate.getTime()) /
      (1000 * 60 * 60 * 24)
  );

  if (daysSinceLmp < 0) {
    throw new Error("LMP cannot be in the future");
  }

  const weeks = Math.floor(daysSinceLmp / 7);
  const days = daysSinceLmp % 7;

  return { weeks, days };
};

module.exports = { calculatePregnancyAge };
