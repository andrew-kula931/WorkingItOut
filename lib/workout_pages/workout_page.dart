import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../workout_components/add_workout.dart';
import '../workout_components/edit_workout.dart';
import 'workout_archive.dart';
import 'routine_planner.dart';
import '../workout_components/wnotes_list.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

class _WorkoutPage extends State<WorkoutPage> {

  late final Box _workoutBox;
  late final Box _workoutNotes;
  late final Box _workoutDocs;
  late List<String> worked;
  late List<String> notworked;

  final List<Color> tileColors = [const Color.fromARGB(255, 250, 145, 145), const Color.fromARGB(255, 250, 205, 205)];


  //Setup for areas worked calculations
  Map<String, int> muscleGroups = {
    'UpperChest': 0,
    'LowerChest': 0,
    'LatissimusDorsi': 0,
    'Rhomboid': 0,
    'Trapezius': 0,
    'Teres': 0,
    'ErectorSpinae': 0,
    'Biceps': 0,
    'Triceps': 0,
    'Deltoids': 0,
    'Obliques': 0,
    'Abs': 0,
    'Hamstrings': 0,
    'Gluteals': 0,
    'Quadriceps': 0,
    'Calves': 0,
  };

  @override
  void initState() {
    super.initState();
    _workoutBox = Hive.box('Workout');
    _workoutNotes = Hive.box('WorkoutNotes');
    _workoutDocs = Hive.box('WorkoutDoc');
    countAreas();
  }

  //Counts the worked areas
  void countAreas() {
    DateTime now = DateTime.now();
    DateTime recentSunday = now.subtract(Duration(days: now.weekday % 7));
    var workoutDoc = _workoutDocs.values.where((e) => e.day.isAfter(recentSunday)).toList();
    for (var i = 0; i < workoutDoc.length; i++) {
      var obj = workoutDoc[i];
      for (var area in obj.workAreas) {
       switch (area) {
        case 'Upper Chest':
          muscleGroups['UpperChest'] = muscleGroups['UpperChest']! + 1;
          break;
        case 'Lower Chest':
          muscleGroups['LowerChest'] = muscleGroups['LowerChest']! + 1;
          break;
        case 'Latissimus Dorsi':
          muscleGroups['LatissimusDorsi'] = muscleGroups['LatissimusDorsi']! + 1;
          break;
        case 'Rhomboid':
          muscleGroups['Rhomboid'] = muscleGroups['Rhomboid']! + 1;
          break;
        case 'Trapezius':
          muscleGroups['Trapezius'] = muscleGroups['Trapezius']! + 1;
          break;
        case 'Teres':
          muscleGroups['Teres'] = muscleGroups['Teres']! + 1;
          break;
        case 'Erector Spinae':
          muscleGroups['ErectorSpinae'] = muscleGroups['ErectorSpinae']! + 1;
          break;
        case 'Biceps':
          muscleGroups['Biceps'] = muscleGroups['Biceps']! + 1;
          break;
        case 'Triceps':
          muscleGroups['Triceps'] = muscleGroups['Triceps']! + 1;
          break;
        case 'Deltoids':
          muscleGroups['Deltoids'] = muscleGroups['Deltoids']! + 1;
          break;
        case 'Obliques':
          muscleGroups['Obliques'] = muscleGroups['Obliques']! + 1;
          break;
        case 'Abs':
          muscleGroups['Abs'] = muscleGroups['Abs']! + 1;
          break;
        case 'Hamstrings':
          muscleGroups['Hamstrings'] = muscleGroups['Hamstrings']! + 1;
          break;
        case 'Gluteals':
          muscleGroups['Gluteals'] = muscleGroups['Gluteals']! + 1;
          break;
        case 'Quadriceps':
          muscleGroups['Quadriceps'] = muscleGroups['Quadriceps']! + 1;
          break;
        case 'Calves':
          muscleGroups['Calves'] = muscleGroups['Calves']! + 1;
          break;
        default:
          break;
        }
      }
    }
    worked = muscleGroups.entries
      .where((entry) => entry.value > 0)
      .map((entry) => entry.key)
      .toList();
    notworked = muscleGroups.entries
      .where((entry) => entry.value == 0)
      .map((entry) => entry.key)
      .toList();
  }

  /*

    Start of Page Here

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Summary Section
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text('Summary:', style: TextStyle(fontSize: 20)),
          ),
          Column(
            children: [
              (MediaQuery.of(context).size.width > 500) ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Areas Worked: '),
                  Container(
                    height: 70,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(worked.join(', ')),
                    ),
                  ),
                ],
              ) : Center(
                child: Column(
                  children: [
                    const Text('Areas Worked: '),
                    Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(worked.join(', ')),
                      ),
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: (MediaQuery.of(context).size.width > 500) ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Areas to Work: '),
                    Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(12)),
                      child: Padding( 
                        padding: const EdgeInsets.all(4),
                        child: Text(notworked.join(', ')),
                      ),
                    ),
                  ],
                ) : Column(
                  children: [
                    const Text('Areas to Work: '),
                    Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(12)),
                      child: Padding( 
                        padding: const EdgeInsets.all(4),
                        child: Text(notworked.join(', ')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),

          /*
          Operation buttons
          */
          Center(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RoutinePlanner()));
                  },
                  child: const Text('Routine Planner'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutArchive()))
                    .then((value) {
                      countAreas();
                      setState(() {});
                    });
                  },
                  child: const Text('Document Workout'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return AddWorkout(workoutBox: _workoutBox);
                      },
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text('Add Workout'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return WNotesList(notesList: _workoutNotes);
                      }
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text('Workout Notes'),
                ),
              ],
            ),
          ),

          //List of workouts created
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: const Text('Workouts:', style: TextStyle(fontSize: 20))
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _workoutBox.length,
              itemBuilder: (context, index) {
                var value = _workoutBox.getAt(index);
                int place = index;
                return Padding(
                  padding: const EdgeInsets.only(left:20, right:20, bottom: 1),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return EditWorkout(workoutDb: _workoutBox, index: index, time: false);
                        },
                      ).then((value) { //This is how I dynamically update the tile
                        setState(() {});
                      });
                    },
                    child: Container ( 
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        tileColor: tileColors[place % 2],
                        title: Text(value.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Workouts: ${value.workouts}', 
                              style: const TextStyle(color: Colors.black)),
                            Text('Work Areas: ${value.workAreas?.join(', ') ?? 'No Work Areas'}',
                              style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}