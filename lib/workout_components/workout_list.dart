import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WorkoutList extends StatefulWidget {
  final Box workoutList;
  const WorkoutList({super.key, required this.workoutList});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 500,
      ),
      child: ListView.builder(
        itemCount: widget.workoutList.length,
        itemBuilder: (context, index) {
          var value = widget.workoutList.getAt(index);
          return Padding(
            padding: const EdgeInsets.only(left:20, right:20, bottom: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, index); //Closes bottom sheet while returning an index
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 250, 223, 223),
                  title: Text(value.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workouts: ${value.workouts}'),
                      Text('Work Areas: ${value.workAreas?.join(', ') ?? 'No Work Areas'}'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}