class PregnancyRiskService {
  static bool hasAbnormalBloodPressure(String bloodPressure) {
    final parts = bloodPressure.split("/");

    if (parts.length != 2) {
      return false;
    }

    final systolic = int.tryParse(parts[0]);
    final diastolic = int.tryParse(parts[1]);

    if (systolic == null || diastolic == null) {
      return false;
    }

    return systolic >= 140 || diastolic >= 90;
  }

  static bool hasSevereSymptoms(String symptoms) {
    final text = symptoms.toLowerCase();

    const warningTerms = [
      "severe bleeding",
      "severe headache",
      "severe abdominal pain",
      "difficulty breathing",
      "loss of consciousness",
    ];

    return warningTerms.any((term) => text.contains(term));
  }

  static bool requiresProviderReview({
    required String bloodPressure,
    required String symptoms,
  }) {
    return hasAbnormalBloodPressure(bloodPressure) ||
        hasSevereSymptoms(symptoms);
  }
}
