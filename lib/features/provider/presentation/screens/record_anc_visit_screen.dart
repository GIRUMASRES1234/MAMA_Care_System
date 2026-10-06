import 'package:flutter/material.dart';

class RecordAncVisitScreen extends StatefulWidget {
  final String patientName;

  const RecordAncVisitScreen({super.key, required this.patientName});

  @override
  State<RecordAncVisitScreen> createState() => _RecordAncVisitScreenState();
}

class _RecordAncVisitScreenState extends State<RecordAncVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  final weightController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final fetalHeartRateController = TextEditingController();
  final symptomsController = TextEditingController();
  final diagnosisController = TextEditingController();
  final recommendationsController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    bloodPressureController.dispose();
    fetalHeartRateController.dispose();
    symptomsController.dispose();
    diagnosisController.dispose();
    recommendationsController.dispose();
    super.dispose();
  }

  void saveVisit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("ANC visit recorded successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Record ANC Visit")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                widget.patientName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Record antenatal care visit",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              const Text(
                "Vital Signs",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Weight (kg)",
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter weight";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: bloodPressureController,
                decoration: const InputDecoration(
                  labelText: "Blood Pressure",
                  hintText: "Example: 120/80",
                  prefixIcon: Icon(Icons.favorite),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter blood pressure";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: fetalHeartRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Fetal Heart Rate (bpm)",
                  prefixIcon: Icon(Icons.favorite_border),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter fetal heart rate";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              const Text(
                "Clinical Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: symptomsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Symptoms",
                  hintText: "Enter patient's symptoms...",
                  prefixIcon: Icon(Icons.sick),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: diagnosisController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Diagnosis",
                  hintText: "Enter diagnosis...",
                  prefixIcon: Icon(Icons.medical_information),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: recommendationsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Recommendations",
                  hintText: "Enter recommendations...",
                  prefixIcon: Icon(Icons.recommend),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: saveVisit,

                  icon: const Icon(Icons.save),

                  label: const Text(
                    "Save ANC Visit",
                    style: TextStyle(fontSize: 16),
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
