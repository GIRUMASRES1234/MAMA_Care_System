import 'package:flutter/material.dart';

class HighRiskPatientsScreen extends StatelessWidget {
  const HighRiskPatientsScreen({super.key});

  final List<Map<String, String>> patients = const [
    {
      "name": "Hanna Getachew",
      "reason": "Abnormal blood pressure recorded",
      "week": "Week 31",
    },
    {
      "name": "Marta Alemu",
      "reason": "Severe symptoms reported",
      "week": "Week 27",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("High-Risk Patients")),

      body: patients.isEmpty
          ? const Center(child: Text("No high-risk patients found."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,

              itemBuilder: (context, index) {
                final patient = patients[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.warning, color: Colors.red),
                    ),

                    title: Text(
                      patient["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "${patient["week"]}\n"
                      "${patient["reason"]}",
                    ),

                    isThreeLine: true,

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {
                      // Open patient details later.
                    },
                  ),
                );
              },
            ),
    );
  }
}
