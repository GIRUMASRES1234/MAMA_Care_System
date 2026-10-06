import 'package:flutter/material.dart';
import 'schedule_appointment_screen.dart';
import 'patients_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/high_risk_patients_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/provider_appointments_screen.dart';
import 'package:mamacare/features/provider/presentation/screens/health_reports_screen.dart';

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthcare Provider"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Dr. Abebe 👋",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.people,
                    title: "Patients",
                    value: "24",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _DashboardCard(
                    icon: Icons.calendar_month,
                    title: "Appointments",
                    value: "8",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.warning,
                    title: "High Risk",
                    value: "3",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _DashboardCard(
                    icon: Icons.medical_information,
                    title: "ANC Visits",
                    value: "12",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            _ActionTile(
              icon: Icons.people,
              title: "View Patients",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientsScreen()),
                );
              },
            ),

            _ActionTile(
              icon: Icons.calendar_month,
              title: "Manage Appointments",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProviderAppointmentsScreen(),
                  ),
                );
              },
            ),

            _ActionTile(
              icon: Icons.warning,
              title: "High-Risk Patients",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HighRiskPatientsScreen(),
                  ),
                );
              },
            ),

            _ActionTile(
              icon: Icons.bar_chart,
              title: "Health Reports",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HealthReportsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.teal),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
