import 'package:flutter/material.dart';
import 'package:mamacare/features/provider/presentation/screens/schedule_appointment_screen.dart';

class ProviderAppointmentsScreen extends StatefulWidget {
  const ProviderAppointmentsScreen({super.key});

  @override
  State<ProviderAppointmentsScreen> createState() =>
      _ProviderAppointmentsScreenState();
}

class _ProviderAppointmentsScreenState
    extends State<ProviderAppointmentsScreen> {
  int selectedTab = 0;

  final List<Map<String, String>> upcomingAppointments = [
    {
      "patient": "Abebech Kebede",
      "type": "Routine ANC Visit",
      "date": "August 20, 2026",
      "time": "10:30 AM",
    },
    {
      "patient": "Almaz Tesfaye",
      "type": "First ANC Visit",
      "date": "August 22, 2026",
      "time": "09:00 AM",
    },
  ];

  final List<Map<String, String>> completedAppointments = [
    {
      "patient": "Hanna Getachew",
      "type": "Routine ANC Visit",
      "date": "August 10, 2026",
      "time": "11:00 AM",
    },
  ];

  final List<Map<String, String>> cancelledAppointments = [
    {
      "patient": "Marta Alemu",
      "type": "Follow-up Visit",
      "date": "August 5, 2026",
      "time": "02:00 PM",
    },
  ];

  List<Map<String, String>> get currentAppointments {
    if (selectedTab == 0) {
      return upcomingAppointments;
    }

    if (selectedTab == 1) {
      return completedAppointments;
    }

    return cancelledAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),

      body: Column(
        children: [
          const SizedBox(height: 10),

          _buildTabs(),

          const SizedBox(height: 10),

          Expanded(
            child: currentAppointments.isEmpty
                ? const Center(child: Text("No appointments found."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentAppointments.length,

                    itemBuilder: (context, index) {
                      final appointment = currentAppointments[index];

                      return _AppointmentCard(
                        patientName: appointment["patient"]!,
                        appointmentType: appointment["type"]!,
                        date: appointment["date"]!,
                        time: appointment["time"]!,
                        status: _getStatus(),
                        onCancel: selectedTab == 0
                            ? () {
                                _cancelAppointment(index);
                              }
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScheduleAppointmentScreen(),
            ),
          );
        },

        icon: const Icon(Icons.add),

        label: const Text("Schedule"),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
        _TabButton(
          title: "Upcoming",
          selected: selectedTab == 0,
          onTap: () {
            setState(() {
              selectedTab = 0;
            });
          },
        ),

        _TabButton(
          title: "Completed",
          selected: selectedTab == 1,
          onTap: () {
            setState(() {
              selectedTab = 1;
            });
          },
        ),

        _TabButton(
          title: "Cancelled",
          selected: selectedTab == 2,
          onTap: () {
            setState(() {
              selectedTab = 2;
            });
          },
        ),
      ],
    );
  }

  String _getStatus() {
    if (selectedTab == 0) {
      return "Scheduled";
    }

    if (selectedTab == 1) {
      return "Completed";
    }

    return "Cancelled";
  }

  void _cancelAppointment(int index) {
    final appointment = upcomingAppointments[index];

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Appointment?"),

          content: Text(
            "Cancel the appointment for "
            "${appointment["patient"]}?",
          ),

          actions: [
            TextButton(onPressed: () {}, child: const Text("No")),

            TextButton(
              onPressed: () {
                setState(() {
                  final cancelled = upcomingAppointments.removeAt(index);

                  cancelledAppointments.add(cancelled);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Appointment cancelled")),
                );
              },

              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String patientName;
  final String appointmentType;
  final String date;
  final String time;
  final String status;
  final VoidCallback? onCancel;

  const _AppointmentCard({
    required this.patientName,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.status,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              appointmentType,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.calendar_month, size: 18),

                const SizedBox(width: 6),

                Text(date),

                const SizedBox(width: 15),

                const Icon(Icons.access_time, size: 18),

                const SizedBox(width: 6),

                Text(time),
              ],
            ),

            if (onCancel != null) ...[
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: onCancel,

                  child: const Text("Cancel Appointment"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,

      child: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
