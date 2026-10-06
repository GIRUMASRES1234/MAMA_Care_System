import 'package:flutter/material.dart';

class HealthGuidanceScreen extends StatefulWidget {
  final String patientName;

  const HealthGuidanceScreen({
    super.key,
    required this.patientName,
  });

  @override
  State<HealthGuidanceScreen> createState() =>
      _HealthGuidanceScreenState();
}

class _HealthGuidanceScreenState
    extends State<HealthGuidanceScreen> {

  final _formKey = GlobalKey<FormState>();

  final titleController =
      TextEditingController();

  final guidanceController =
      TextEditingController();

  DateTime? followUpDate;

  @override
  void dispose() {
    titleController.dispose();
    guidanceController.dispose();
    super.dispose();
  }

  Future<void> selectFollowUpDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        followUpDate = selectedDate;
      });
    }
  }

  void saveGuidance() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (followUpDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a follow-up date.",
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Health guidance saved successfully.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Guidance",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // Patient
              Text(
                widget.patientName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Provider follow-up guidance",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Title
              TextFormField(
                controller: titleController,

                decoration: const InputDecoration(
                  labelText: "Guidance Title",
                  hintText:
                      "Example: Follow-up ANC visit",
                  prefixIcon:
                      Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter a guidance title";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Guidance
              TextFormField(
                controller: guidanceController,

                maxLines: 6,

                decoration: const InputDecoration(
                  labelText: "Guidance",
                  hintText:
                      "Enter follow-up instructions...",
                  prefixIcon:
                      Icon(Icons.notes),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter guidance";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Follow-up date
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                  ),

                  title: const Text(
                    "Follow-up Date",
                  ),

                  subtitle: Text(
                    followUpDate == null
                        ? "No date selected"
                        : "${followUpDate!.day}/"
                          "${followUpDate!.month}/"
                          "${followUpDate!.year}",
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: selectFollowUpDate,
                ),
              ),

              const SizedBox(height: 30),

              // Save
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: saveGuidance,

                  icon: const Icon(
                    Icons.save,
                  ),

                  label: const Text(
                    "Save Guidance",
                    style: TextStyle(
                      fontSize: 16,
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