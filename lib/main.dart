import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'workout_pages/workout_page.dart';
import 'data/workout_db.dart';
import 'data/gaming_db.dart';
import 'workout_pages/workout_archive.dart';
import 'workout_pages/routine_planner.dart';
import 'gaming_pages/gaming_home.dart';
import 'gaming_pages/game_profile.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //final appDocumentsDir = await pathProvider.getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocumentsDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutDbAdapter());

  Hive.registerAdapter(WorkoutDocAdapter());

  Hive.registerAdapter(WorkoutScheduleAdapter());

  Hive.registerAdapter(WorkoutNotesAdapter());

  Hive.registerAdapter(GamesDbAdapter());

  Hive.registerAdapter(RecentGamesAdapter());

  Hive.registerAdapter(GameGoalsAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Working It Out',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const WorkoutApp(title: 'Working It Out Home Page'),
    );
  }
}

class WorkoutApp extends StatefulWidget {
  const WorkoutApp({super.key, required this.title});

  final String title;

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

//First class displayed on starter page
class _WorkoutAppState extends State<WorkoutApp> {
  final _formKey = GlobalKey<FormState>();
  String workoutType = '';
  int duration = 0;

  //Color variables
  var updateWorkoutColor = Colors.lightGreen;
  var viewWorkoutHistoryColor = Colors.lightGreen;
  var routinePlannerColor = Colors.lightGreen;
  var gameListColor = Colors.lightGreen;
  var recentGameColor = Colors.lightGreen;

  //Dropdown menu variables
  bool gamingMenu = false;
  bool workoutMenu = false;
  bool orgMenu = false;
  bool funMenu = false;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void _gamingMenu() {
    setState(() {
      gamingMenu = !gamingMenu;
    });
  }

  void _workoutMenu() {
    setState(() {
      workoutMenu = !workoutMenu;
    });
  }

  void _orgMenu() {
    setState(() {
      orgMenu = !orgMenu;
    });
  }

  void _funMenu() {
    setState(() {
      funMenu = !funMenu;
    });
  }

  void _closeWorkoutBoxes() async {
    if(Hive.isBoxOpen('Workout')) {
      Box workoutBox = Hive.box('Workout');
      await workoutBox.close();
    }
    if(Hive.isBoxOpen('WorkoutDoc')) {
      Box workoutDoc = Hive.box('WorkoutDoc');
      await workoutDoc.close();
    }
    if(Hive.isBoxOpen('WorkoutSchedule')) {
      Box workoutSchedule = Hive.box('WorkoutSchedule');
      await workoutSchedule.close();
    }
    if(Hive.isBoxOpen('WorkoutNotes')) {
      Box workoutNotes = Hive.box('WorkoutNotes');
      await workoutNotes.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Working It Out'), 
      centerTitle: true,
      titleTextStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 2, 46, 14),) ),
      body: Form(
        key: _formKey,

        //Main page is the navagation row stacked on the main column
        child: Stack(
          children: [

            //Main page
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //Top Info
                Container(
                  margin: const EdgeInsets.only(left: 40, top: 60),
                  child: const Text('This Week:', style: TextStyle(fontSize: 30)),
                ),

                //The Event bar
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  decoration: const BoxDecoration(color: Colors.lightGreen),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Events', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),

                //The goals bar
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(color: Colors.green),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Goals', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),

                //The workout bar
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(color: Colors.lightGreen),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Workouts', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),

                //Health Summary
                const Column(
                  children: [
                    Text('Health Summary', style: TextStyle(fontSize: 30)),

                    //Calories burned
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calories burned this week: '),
                          Text('Fill in some value.'),
                        ],
                      ),
                    ),

                    //Calories consumed
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calories consumed:  '),
                          Text('Fill in some value.'),
                        ],
                      ),
                    ),

                    //Next workout to do
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Next Workout: '),
                          Text('Fill in some value.'),
                        ],
                      ),
                    ),

                    //Underworked areas
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Underworked areas: '),
                          Text('Fill in some value.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /*
              Navigation Bar 
            */
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                //The page options at the top of the main page
                Row (
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _gamingMenu,
                        onLongPress: () async {
                          if (!Hive.isBoxOpen('Games')) {
                            await Hive.openBox('Games');                   
                          }
                          if (!Hive.isBoxOpen('RecentGames')) {
                            await Hive.openBox('RecentGames');
                            if (Hive.box('RecentGames').isEmpty) {
                              RecentGames data = RecentGames(recents: []);
                              await Hive.box('RecentGames').add(data);
                            }
                          }
                          if (!Hive.isBoxOpen('GameGoals')) {
                            await Hive.openBox('GameGoals');
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const GamingHome()));
                        },
                        child:Container(
                          width: screenWidth * .25,
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Center(
                            child: Text('Gaming'),
                          ),
                        ),
                      ),
                      if (gamingMenu)
                        SizedBox(
                          width: screenWidth * .25,
                          child: Column (
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (!Hive.isBoxOpen('Games')) {
                                    await Hive.openBox('Games');                   
                                  }
                                  if (!Hive.isBoxOpen('RecentGames')) {
                                    await Hive.openBox('RecentGames');
                                    if (Hive.box('RecentGames').isEmpty) {
                                      RecentGames data = RecentGames(recents: []);
                                      await Hive.box('RecentGames').add(data);
                                    }
                                  }
                                  if (!Hive.isBoxOpen('GameGoals')) {
                                    await Hive.openBox('GameGoals');
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GamingHome()));
                                },
                                child: MouseRegion(
                                  onEnter: (event) => setState(() => gameListColor = Colors.green),
                                  onExit: (event) => setState(() => gameListColor = Colors.lightGreen),
                                  child: Container (
                                    decoration: BoxDecoration(color: gameListColor),
                                    width: MediaQuery.of(context).size.width * .25,
                                    height: 40,
                                    child: const Center(
                                      child: Text("Games List"),
                                    )
                                  )
                                )
                              ),
                              
                              GestureDetector(
                                onTap: () async {
                                  if (!Hive.isBoxOpen('Games')) {
                                    await Hive.openBox('Games');                   
                                  }
                                  if (!Hive.isBoxOpen('RecentGames')) {
                                    await Hive.openBox('RecentGames');
                                  }
                                  if (!Hive.isBoxOpen('GameGoals')) {
                                    await Hive.openBox('GameGoals');
                                  }

                                  var recentGameBox = Hive.box('RecentGames').getAt(0);
                                  if (recentGameBox != null && recentGameBox.recents.isNotEmpty) {
                                    var gameLocation = Hive.box('Games').getAt(Hive.box('RecentGames').getAt(0).recents[0]);
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  
                                      GameProfile(gameInfo: gameLocation, index: Hive.box('RecentGames').getAt(0).recents[0])));
                                  }
                                },
                                child: MouseRegion(
                                  onEnter: (event) => setState(() => recentGameColor = Colors.green),
                                  onExit: (event) => setState(() => recentGameColor = Colors.lightGreen),
                                  child: Container (
                                    decoration: BoxDecoration(color: recentGameColor),
                                    width: MediaQuery.of(context).size.width * .25,
                                    height: 40,
                                    child: const Center(
                                      child: Text("Most Recent"),
                                    )
                                  )
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _workoutMenu,
                          onLongPress: () async {
                            if(!Hive.isBoxOpen('Workout')) {
                              await Hive.openBox('Workout');
                            }
                            if(!Hive.isBoxOpen('WorkoutDoc')) {
                              await Hive.openBox('WorkoutDoc');
                            }
                            if(!Hive.isBoxOpen('WorkoutSchedule')) {
                              await Hive.openBox('WorkoutSchedule');
                            }
                            if(!Hive.isBoxOpen('WorkoutNotes')) {
                              await Hive.openBox('WorkoutNotes');
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()))
                            .then((value) {
                              _closeWorkoutBoxes();
                            });
                          },
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Workout'),
                            ),
                          ),
                        ),
                        if (workoutMenu)
                          Container(
                            width: screenWidth * .25,
                            decoration: const BoxDecoration(color: Colors.lightGreen),
                            child: Column (
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if(!Hive.isBoxOpen('Workout')) {
                                      await Hive.openBox('Workout');
                                    }
                                    if(!Hive.isBoxOpen('WorkoutDoc')) {
                                      await Hive.openBox('WorkoutDoc');
                                    }
                                    if(!Hive.isBoxOpen('WorkoutSchedule')) {
                                      await Hive.openBox('WorkoutSchedule');
                                    }
                                    if(!Hive.isBoxOpen('WorkoutNotes')) {
                                      await Hive.openBox('WorkoutNotes');
                                    }
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()))
                                    .then((value) {
                                      _closeWorkoutBoxes();
                                    });
                                  },
                                  child: MouseRegion(
                                    onEnter: (event) => setState(() => updateWorkoutColor = Colors.green),
                                    onExit: (event) => setState(() => updateWorkoutColor = Colors.lightGreen),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(color: updateWorkoutColor),
                                      child: const Center(child: Text("Update Workout Info"),) 
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if(!Hive.isBoxOpen('Workout')) {
                                      await Hive.openBox('Workout');
                                    }
                                    if(!Hive.isBoxOpen('WorkoutDoc')) {
                                      await Hive.openBox('WorkoutDoc');
                                    }
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutArchive()))
                                    .then((value) {
                                      _closeWorkoutBoxes();
                                    });
                                  },
                                  child: MouseRegion(
                                    onEnter: (event) => setState(() => viewWorkoutHistoryColor = Colors.green),
                                    onExit: (event) => setState(() => viewWorkoutHistoryColor = Colors.lightGreen),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(color: viewWorkoutHistoryColor),
                                      child: const Center(child: Text("View History"),) 
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if(!Hive.isBoxOpen('Workout')) {
                                      await Hive.openBox('Workout');
                                    }
                                    if(!Hive.isBoxOpen('WorkoutSchedule')) {
                                      await Hive.openBox('WorkoutSchedule');
                                    }
                                    //ignore: use_build_context_synchronously
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RoutinePlanner()))
                                    .then((value) {
                                      _closeWorkoutBoxes();
                                    });
                                  },
                                  child: MouseRegion(
                                    onEnter: (event) => setState(() => routinePlannerColor = Colors.green),
                                    onExit: (event) => setState(() => routinePlannerColor = Colors.lightGreen),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(color: routinePlannerColor),
                                      child: const Center(child: Text("Routine Planner"),) 
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _orgMenu,
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Organization'),
                            ),
                          ),
                        ),
                        if (orgMenu)
                          Container(
                            width: screenWidth * .25,
                            decoration: const BoxDecoration(color: Colors.green),
                            child: const Column (
                              children: [
                                Text("Edit/Add Events"),
                                Text('Calendar'),
                              ],
                            )
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _funMenu,
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Fun'),
                            ),
                          ),
                        ),
                        if (funMenu)
                          Container(
                            width: screenWidth * .25,
                            decoration: const BoxDecoration(color: Colors.green),
                            child: const Column (
                              children: [
                                Text("Solitare"),
                                Text('Poker'),
                                Text('Random Wheel'),
                              ],
                            )
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}