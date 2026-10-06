import 'package:flutter/material.dart';

class HealthReportsScreen extends StatelessWidget {
  const HealthReportsScreen({super.key});

  // Temporary data.
  // Later this will come from the backend.
  final int totalPatients = 24;
  final int ancVisits = 86;
  final int upcomingAppointments = 12;
  final int highRiskPatients = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Reports")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Health Statistics",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              children: [
                _StatisticCard(
                  title: "Total Patients",
                  value: "$totalPatients",
                  icon: Icons.people,
                ),

                _StatisticCard(
                  title: "ANC Visits",
                  value: "$ancVisits",
                  icon: Icons.medical_services,
                ),

                _StatisticCard(
                  title: "Upcoming Visits",
                  value: "$upcomingAppointments",
                  icon: Icons.calendar_month,
                ),

                _StatisticCard(
                  title: "High-Risk Patients",
                  value: "$highRiskPatients",
                  icon: Icons.warning,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "ANC Visit Activity",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Completed ANC Visits",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      height: 18,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.72,

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text("72% of scheduled ANC visits completed"),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Report generation will be connected to the backend later.",
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.description),

                label: const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 30),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MonitoringRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MonitoringRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
