import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ANC Appointments")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Upcoming Appointment",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.calendar_month)),

              title: const Text("Monday, August 10"),

              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 5),

                  Text("10:30 AM"),

                  Text("St. Paul Hospital"),

                  SizedBox(height: 5),

                  Text(
                    "Status: Scheduled",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),

              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Previous Appointments",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("15 July 2026"),
              subtitle: const Text("Completed"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("10 June 2026"),
              subtitle: const Text("Completed"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("5 May 2026"),
              subtitle: const Text("Completed"),
            ),
          ),
        ],
      ),
    );
  }
}
