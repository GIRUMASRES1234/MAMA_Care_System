import 'package:flutter/material.dart';

class AncVisitHistoryScreen extends StatelessWidget {
  final String patientName;

  const AncVisitHistoryScreen({super.key, required this.patientName});

  final List<Map<String, dynamic>> visits = const [
    {
      "date": "August 15, 2026",
      "weight": "65 kg",
      "bloodPressure": "120/80",
      "fetalHeartRate": "145 bpm",
      "symptoms": "No reported symptoms",
      "diagnosis": "Normal pregnancy",
      "recommendation": "Continue regular ANC visits.",
    },
    {
      "date": "July 15, 2026",
      "weight": "64 kg",
      "bloodPressure": "118/78",
      "fetalHeartRate": "148 bpm",
      "symptoms": "Mild fatigue",
      "diagnosis": "Normal pregnancy",
      "recommendation": "Continue healthy diet and hydration.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ANC Visit History")),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: visits.length,

        itemBuilder: (context, index) {
          final visit = visits[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.medical_information),
              ),

              title: Text(
                visit["date"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(
                "Weight: ${visit["weight"]}\n"
                "BP: ${visit["bloodPressure"]}\n"
                "Fetal HR: ${visit["fetalHeartRate"]}",
              ),

              isThreeLine: true,

              trailing: const Icon(Icons.arrow_forward_ios, size: 16),

              onTap: () {
                _showVisitDetails(context, visit);
              },
            ),
          );
        },
      ),
    );
  }

  void _showVisitDetails(BuildContext context, Map<String, dynamic> visit) {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                patientName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(visit["date"], style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),

              _DetailRow(title: "Weight", value: visit["weight"]),

              _DetailRow(
                title: "Blood Pressure",
                value: visit["bloodPressure"],
              ),

              _DetailRow(
                title: "Fetal Heart Rate",
                value: visit["fetalHeartRate"],
              ),

              _DetailRow(title: "Symptoms", value: visit["symptoms"]),

              _DetailRow(title: "Diagnosis", value: visit["diagnosis"]),

              _DetailRow(
                title: "Recommendation",
                value: visit["recommendation"],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 4),

          Text(value),
        ],
      ),
    );
  }
}
