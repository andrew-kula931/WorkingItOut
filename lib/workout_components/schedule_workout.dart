import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/workout_db.dart';

class PlanWorkout extends StatefulWidget {
  final int index;
  const PlanWorkout({super.key, required this.index});

  @override
  State<PlanWorkout> createState() => PlanWorkoutState();
}

class PlanWorkoutState extends State<PlanWorkout> {
  final _formKey = GlobalKey<FormState>();

  late final Box workoutBox;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    workoutBox = Hive.box('Workout');
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateTimeController.text = picked.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: TextFormField(
                readOnly: true,
                controller: _dateTimeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please set date';
                  }
                  return null;
                },
                onTap: () {
                  _selectDate(context);
                },
                decoration: const InputDecoration(hintText: 'Select Date'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var box = Hive.box('WorkoutSchedule');
                  var workoutData = workoutBox.getAt(widget.index);
                  WorkoutSchedule data = WorkoutSchedule(
                    name: workoutData.name,
                    workouts: workoutData.workouts,
                    workAreas: workoutData.workAreas,
                    day: DateTime.parse(_dateTimeController.text),
                  );
                  await box.add(data);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('Schedule'),
            ),
          ),
        ],
      )
    );
  }
}