import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../workout_components/workout_list.dart';
import '../workout_components/schedule_workout.dart';

class RoutinePlanner extends StatefulWidget{
  const RoutinePlanner({super.key});

  @override
  State<RoutinePlanner> createState() => _RoutinePlannerState();
}

class _RoutinePlannerState extends State<RoutinePlanner> {
  late final Box workoutList;
  late final Box scheduleBox;

  @override
  void initState() {
    super.initState();
    workoutList = Hive.box('Workout');
    scheduleBox = Hive.box('WorkoutSchedule');
  }

  final List<Color> colors = [const Color.fromARGB(255, 250, 192, 195), const Color.fromARGB(255, 187, 133, 133)];

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
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
          return PlanWorkout(index: result);
        }
      ).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> weekDays = List.generate(7, (index) => now.add(Duration(days: index)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Planner')
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                _getWorkout();
              },
              child: const Text('Schedule Workout'),
            )
          ),

          //This is the week list
          SizedBox(
            height: (MediaQuery.of(context).size.height * .82),
            child: ListView.builder(
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                DateTime day = weekDays[index];
                var boxInfo = scheduleBox.values.where((e) => e.day.day == day.day).toList();
                return ListTile(
                  title: Text('${day.month}/${day.day} - ${_getWeekdayName(day.weekday)}'),
                  subtitle: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: boxInfo.length,
                      itemBuilder: (context, innerIndex) {
                        return Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: colors[(innerIndex % 2 == 0) ? 0 : 1],
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(boxInfo[innerIndex].name ?? 'No Name'),
                                    Container( 
                                      width: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1))),
                                    Text(boxInfo[innerIndex].workouts ?? 'No Workouts'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      for (int i = 0; i < scheduleBox.length; i++) {
                                        if (boxInfo[innerIndex] == scheduleBox.getAt(i)) {
                                          await scheduleBox.deleteAt(i);
                                          break;
                                        }
                                      }
                                      setState(() {});
                                    },
                                    child: const Text('Remove'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}