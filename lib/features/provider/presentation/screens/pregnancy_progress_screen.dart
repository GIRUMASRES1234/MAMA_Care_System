import 'package:flutter/material.dart';

class PregnancyProgressScreen extends StatelessWidget {
  final String patientName;
  final int pregnancyWeek;

  const PregnancyProgressScreen({
    super.key,
    required this.patientName,
    required this.pregnancyWeek,
  });

  String get trimester {
    if (pregnancyWeek <= 13) {
      return "1st Trimester";
    } else if (pregnancyWeek <= 27) {
      return "2nd Trimester";
    } else {
      return "3rd Trimester";
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = pregnancyWeek / 40;

    return Scaffold(
      appBar: AppBar(title: const Text("Pregnancy Progress")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Patient
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    child: Icon(Icons.pregnant_woman, size: 45),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Pregnancy Progress
            const Text(
              "Pregnancy Progress",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    Text(
                      "Week $pregnancyWeek of 40",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    LinearProgressIndicator(value: progress, minHeight: 12),

                    const SizedBox(height: 10),

                    Text("${(progress * 100).round()}% completed"),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        _ProgressInfo(title: "Week", value: "$pregnancyWeek"),

                        _ProgressInfo(title: "Trimester", value: trimester),

                        _ProgressInfo(title: "Total", value: "40 weeks"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ANC Activities
            const Text(
              "ANC Activities",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _ActivityTile(title: "First ANC Visit", completed: true),

            _ActivityTile(title: "Second ANC Visit", completed: true),

            _ActivityTile(title: "Third ANC Visit", completed: true),

            _ActivityTile(title: "Next ANC Visit", completed: false),

            const SizedBox(height: 25),

            // Expected Delivery
            const Text(
              "Delivery Information",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.event, color: Colors.teal),

                title: const Text("Expected Delivery Date"),

                subtitle: const Text("October 15, 2026"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final String title;
  final String value;

  const _ProgressInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),

        const SizedBox(height: 4),

        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final bool completed;

  const _ActivityTile({required this.title, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
        ),

        title: Text(title),

        trailing: Text(
          completed ? "Completed" : "Pending",
          style: TextStyle(color: completed ? Colors.green : Colors.grey),
        ),
      ),
    );
  }
}
