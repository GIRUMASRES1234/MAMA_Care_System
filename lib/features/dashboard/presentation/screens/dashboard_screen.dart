import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MamaCare Ethiopia"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Mother 👋",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text("Welcome back to your pregnancy journey."),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text("Pregnancy Progress"),
                subtitle: const Text("Week 18"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.blue),
                title: const Text("Next ANC Appointment"),
                subtitle: const Text("August 5, 2026"),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.medication, color: Colors.green),
                title: const Text("Medication Reminder"),
                subtitle: const Text("Take Iron Tablet at 8:00 PM"),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.orange),
                title: const Text("Health Tip"),
                subtitle: const Text(
                  "Drink enough water and eat healthy foods.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
