import 'package:flutter/material.dart';
import 'package:mamacare/features/provider/presentation/screens/record_anc_visit_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/anc_visit_history_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/pregnancy_progress_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/health_guidance_screen.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientName;
  final int pregnancyWeek;
  final String status;

  const PatientDetailsScreen({
    super.key,
    required this.patientName,
    required this.pregnancyWeek,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    child: Icon(Icons.person, size: 50),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Pregnancy: Week $pregnancyWeek",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _SectionTitle(title: "Personal Information"),

            _InfoCard(
              icon: Icons.phone,
              title: "Phone Number",
              value: "+251 912 345 678",
            ),

            _InfoCard(
              icon: Icons.location_on,
              title: "Address",
              value: "Addis Ababa, Ethiopia",
            ),

            const SizedBox(height: 20),

            _SectionTitle(title: "Pregnancy Information"),

            _InfoCard(
              icon: Icons.pregnant_woman,
              title: "Current Pregnancy",
              value: "Week $pregnancyWeek",
            ),

            _InfoCard(
              icon: Icons.event,
              title: "Expected Delivery Date",
              value: "October 15, 2026",
            ),

            _InfoCard(
              icon: Icons.calendar_today,
              title: "Last Menstrual Period",
              value: "January 8, 2026",
            ),

            _InfoCard(
              icon: Icons.family_restroom,
              title: "Pregnancy History",
              value: "Second pregnancy",
            ),

            const SizedBox(height: 20),

            _SectionTitle(title: "Medical Information"),

            _InfoCard(
              icon: Icons.medical_information,
              title: "Current Medical Conditions",
              value: "No recorded conditions",
            ),

            _InfoCard(
              icon: Icons.health_and_safety,
              title: "Current Symptoms",
              value: "No reported symptoms",
            ),

            const SizedBox(height: 20),

            _SectionTitle(title: "ANC Information"),
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecordAncVisitScreen(patientName: patientName),
                    ),
                  );
                },

                icon: const Icon(Icons.add),

                label: const Text("Record ANC Visit"),
              ),
            ),
            _InfoCard(
              icon: Icons.calendar_month,
              title: "Next ANC Appointment",
              value: "August 20, 2026 at 10:30 AM",
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.teal),

                title: const Text("ANC Visit History"),

                subtitle: const Text("View completed ANC visits"),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AncVisitHistoryScreen(patientName: patientName),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            _SectionTitle(title: "Pregnancy Progress"),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Week $pregnancyWeek of 40",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: pregnancyWeek / 40,
                      minHeight: 10,
                    ),

                    const SizedBox(height: 10),

                    Text("Status: $status"),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.pregnant_woman, color: Colors.teal),

                title: const Text("Pregnancy Progress"),

                subtitle: const Text("Monitor pregnancy development"),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PregnancyProgressScreen(
                        patientName: patientName,
                        pregnancyWeek: pregnancyWeek,
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.health_and_safety,
                  color: Colors.teal,
                ),

                title: const Text("Health Guidance"),

                subtitle: const Text("Provide follow-up guidance"),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HealthGuidanceScreen(patientName: patientName),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(icon, color: Colors.teal),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(value),
      ),
    );
  }
}
