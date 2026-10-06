import 'package:flutter/material.dart';
import 'patient_details_screen.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  final List<Map<String, dynamic>> patients = const [
    {
      "name": "Abebech Kebede",
      "week": 24,
      "status": "Active",
      "highRisk": false,
    },
    {
      "name": "Almaz Tesfaye",
      "week": 18,
      "status": "Active",
      "highRisk": false,
    },
    {
      "name": "Hanna Getachew",
      "week": 31,
      "status": "High Risk",
      "highRisk": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patients")),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,

        itemBuilder: (context, index) {
          final patient = patients[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: CircleAvatar(child: const Icon(Icons.person)),

              title: Text(
                patient["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text("Pregnancy: Week ${patient["week"]}"),

              trailing: patient["highRisk"]
                  ? const Icon(Icons.warning, color: Colors.red)
                  : const Icon(Icons.arrow_forward_ios, size: 16),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailsScreen(
                      patientName: patient["name"],
                      pregnancyWeek: patient["week"],
                      status: patient["status"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
