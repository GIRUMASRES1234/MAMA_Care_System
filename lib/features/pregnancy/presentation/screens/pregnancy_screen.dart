import 'package:flutter/material.dart';

class PregnancyScreen extends StatelessWidget {
  const PregnancyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pregnancy Progress")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Week 18",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const LinearProgressIndicator(value: 18 / 40, minHeight: 10),

            const SizedBox(height: 10),

            const Text(
              "Second Trimester",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.child_care),
                title: const Text("Baby Development"),
                subtitle: const Text(
                  "Baby is about the size of a sweet potato.\n"
                  "Hearing is improving.\n"
                  "Baby can move actively.",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text("Mother's Changes"),
                subtitle: const Text(
                  "Your belly is growing.\n"
                  "You may begin to feel regular baby kicks.",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text("Weekly Health Tip"),
                subtitle: const Text(
                  "Drink enough water and eat iron-rich foods.",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Next ANC Visit"),
                subtitle: const Text("5 August 2026"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
