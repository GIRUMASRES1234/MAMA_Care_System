import 'package:flutter/material.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  const ScheduleAppointmentScreen({super.key});

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedPatient;
  String? selectedAppointmentType;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final notesController = TextEditingController();

  final List<String> patients = [
    "Abebech Kebede",
    "Almaz Tesfaye",
    "Hanna Getachew",
    "Marta Alemu",
  ];

  final List<String> appointmentTypes = [
    "First ANC Visit",
    "Routine ANC Visit",
    "Follow-up Visit",
    "Ultrasound",
    "Vaccination",
  ];

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void scheduleAppointment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an appointment date")),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an appointment time")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment scheduled successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Appointment")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Schedule ANC Appointment",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create an appointment for a pregnant woman.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Patient",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                value: selectedPatient,

                items: patients.map((patient) {
                  return DropdownMenuItem(value: patient, child: Text(patient));
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedPatient = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return "Please select a patient";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Appointment Type",
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                value: selectedAppointmentType,

                items: appointmentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedAppointmentType = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return "Please select appointment type";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Appointment Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: selectDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/"
                              "${selectedDate!.month}/"
                              "${selectedDate!.year}",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Appointment Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: selectTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    selectedTime == null
                        ? "Select Time"
                        : selectedTime!.format(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: notesController,
                maxLines: 4,

                decoration: InputDecoration(
                  labelText: "Notes",
                  hintText: "Add appointment notes...",
                  prefixIcon: const Icon(Icons.notes),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: scheduleAppointment,

                  icon: const Icon(Icons.calendar_month),

                  label: const Text(
                    "Schedule Appointment",
                    style: TextStyle(fontSize: 16),
                  ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
