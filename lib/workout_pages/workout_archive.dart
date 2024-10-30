import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../workout_components/edit_workout.dart';
import '../workout_components/workout_list.dart';
import '../workout_components/edit_doc.dart';


class WorkoutArchive extends StatefulWidget {
  const WorkoutArchive({super.key});

  @override
  State<WorkoutArchive> createState() => _WorkoutArchiveState();
}

class _WorkoutArchiveState extends State<WorkoutArchive> {
  late final Box _filteredList;
  late final Box workoutList;

  final List<Color> tileColors = [const Color.fromARGB(255, 190, 63, 63), const Color.fromARGB(255, 236, 161, 161)];

  @override
  void initState() {
    super.initState();
    workoutList = Hive.box('Workout');
    _filteredList = Hive.box('WorkoutDoc');
  }

  Future<void> _getWorkout() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return WorkoutList(workoutList: workoutList);
      }
    );
    if (result != null) {
      showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context) {
          return EditWorkout(workoutDb: workoutList, index: result, time: true);
        }
      ).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documented Workouts'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: _filteredList.length, 
              itemBuilder: (context, index) {
                var doc = _filteredList.getAt(index);
                int place = index;
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      // ignore: use_build_context_synchronously
                      context: context, 
                      builder: (context) {
                        return EditDocItem(workoutDb: _filteredList, index: place);
                      }
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: ListTile(
                    title: Text(doc.name),
                    tileColor: tileColors[place % 2],
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Workouts: ${doc.workouts}'),
                        Text('Work Areas: ${doc.workAreas?.join(', ') ?? 'No Areas'}'),
                        Text('Day: ${doc.day.month}/${doc.day.day}/${doc.day.year}'),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),

          //Bottom record button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _getWorkout();
                  },
                  child: const Text('Record Workout')
                ),
              ),
            ],
          ),
        ]
      )
    );
  }
}