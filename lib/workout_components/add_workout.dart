import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/workout_db.dart';

class AddWorkout extends StatefulWidget {
  final Box workoutBox;
  const AddWorkout({super.key, required this.workoutBox});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  // ignore: non_constant_identifier_names
  final List<String> MUSCLE_GROUPS = [
    'Upper Chest',
    'Lower Chest',
    'Latissimus Dorsi',
    'Rhomboid',
    'Trapezius',
    'Teres',
    'Erector Spinae',
    'Biceps',
    'Triceps',
    'Deltoids',
    'Obliques',
    'Abs',
    'Hamstrings',
    'Gluteals',
    'Quadriceps',
    'Calves'
  ];
  String? dropDownValue;
  bool groupList = false;

  //Storing inputted values
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _workoutsFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _workoutsController = TextEditingController();
  List<String> dropDownValues = [];

  @override
  void dispose() {
    _nameFocus.dispose();
    _workoutsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Add Workout', style: TextStyle(fontSize: 20)),
              ],
            ),

            //Name Row
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Name: '),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      focusNode: _nameFocus,
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),

            //Exercises Row
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Exercises: '),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      focusNode: _workoutsFocus,
                      controller: _workoutsController,
                      decoration: const InputDecoration(
                          labelText: 'Excercises',
                          border: OutlineInputBorder()),
                      maxLines: 5,
                      minLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            //Muscle Groups worked
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Muscle Groups Worked: '),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        groupList = !groupList;
                      });
                    },
                    child: const Text('Muscles Worked'),
                  ),
                ],
              ),
            ),
            if (groupList)
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: ListView(
                    children: MUSCLE_GROUPS.map((String item) {
                      return CheckboxListTile(
                        title: Text(item),
                        value: dropDownValues.contains(item),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              dropDownValues.add(item);
                            } else {
                              dropDownValues.remove(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

            //Save button
            ElevatedButton(
              onPressed: () async {
                var box = Hive.box('Workout');
                WorkoutDb data = WorkoutDb(
                  name: _nameController.text,
                  workouts: _workoutsController.text,
                  workAreas: dropDownValues,
                );
                await box.add(data);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Save Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
