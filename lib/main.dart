// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'workout_pages/workout_page.dart';
import 'data/workout_db.dart';
import 'data/gaming_db.dart';
import 'workout_pages/workout_archive.dart';
import 'workout_pages/routine_planner.dart';
import 'gaming_pages/gaming_home.dart';
import 'gaming_pages/game_profile.dart';
import 'fun_pages/spinner.dart';
import 'data/spinner_db.dart';
import 'fun_pages/solitare.dart';
import 'fun_pages/poker.dart';
import 'fun_pages/chess/chess.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final appDocumentsDir = await pathProvider.getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocumentsDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutDbAdapter());

  Hive.registerAdapter(WorkoutDocAdapter());

  Hive.registerAdapter(WorkoutScheduleAdapter());
  await Hive.openBox('WorkoutSchedule');

  Hive.registerAdapter(WorkoutNotesAdapter());

  Hive.registerAdapter(GamesDbAdapter());

  Hive.registerAdapter(RecentGamesAdapter());

  Hive.registerAdapter(GameGoalsAdapter());

  Hive.registerAdapter(SpinnerDataAdapter());

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

  final Uri _url = Uri.parse('https://buchritter.onrender.com');

  //Color variables
  Map<String, Color> colorMap = {
    'updateWorkoutColor': Colors.lightGreen,
    'viewWorkoutHistoryColor': Colors.lightGreen,
    'routinePlannerColor': Colors.lightGreen,
    'gameListColor': Colors.lightGreen,
    'recentGameColor': Colors.lightGreen,
    'solitareListColor': Colors.lightGreen,
    'pokerListColor': Colors.lightGreen,
    'chessListColor': Colors.lightGreen
  };

  //Dropdown menu variables
  bool gamingMenu = false;
  bool workoutMenu = false;
  bool orgMenu = false;
  bool funMenu = false;

  //Time set up variables for this week
  final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  final DateTime twoDaysLater = DateTime.now().add(const Duration(days: 2));
  late List<dynamic> scheduledWorkouts;

  @override
  void initState() {
    super.initState();
    scheduledWorkouts = Hive.box('WorkoutSchedule')
        .values
        .where(
            (x) => (x.day.isAfter(yesterday) && x.day.isBefore(twoDaysLater)))
        .toList();
  }

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
    if (Hive.isBoxOpen('Workout')) {
      Box workoutBox = Hive.box('Workout');
      await workoutBox.close();
    }
    if (Hive.isBoxOpen('WorkoutDoc')) {
      Box workoutDoc = Hive.box('WorkoutDoc');
      await workoutDoc.close();
    }
    if (Hive.isBoxOpen('WorkoutNotes')) {
      Box workoutNotes = Hive.box('WorkoutNotes');
      await workoutNotes.close();
    }

    scheduledWorkouts = Hive.box('WorkoutSchedule')
        .values
        .where(
            (x) => (x.day.isAfter(yesterday) && x.day.isBefore(twoDaysLater)))
        .toList();

    if (Hive.isBoxOpen('WorkoutSchedule')) {
      Box workoutSchedule = Hive.box('WorkoutSchedule');
      await workoutSchedule.close();
    }

    setState(() {});
  }

  void _closeGameBoxes() async {
    if (Hive.isBoxOpen('Games')) {
      Box games = Hive.box('Games');
      await games.close();
    }
    if (Hive.isBoxOpen('RecentGames')) {
      Box recents = Hive.box('RecentGames');
      await recents.close();
    }
    if (Hive.isBoxOpen('GameGoals')) {
      Box goals = Hive.box('GameGoals');
      await goals.close();
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

/*
    Widget Tree Starter here
*/

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Working It Out'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 2, 46, 14),
          )),
      body: Form(
        key: _formKey,

        //Main page is the navagation row stacked on the main column
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            //Main page
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: ListView(scrollDirection: Axis.vertical, children: [
                  // Buch Ritter advertisement
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 5),
                    child: Container(
                      height: 200,
                      color: const Color.fromARGB(255, 3, 8, 60),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    Text("Check out Buch Ritter",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 2),
                                        child: Icon(Icons.book,
                                            color: Colors.white))
                                  ]),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 40, bottom: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    Text(
                                        "Features a place to write and a place to review. WIP",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ]),
                            ),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: _launchUrl,
                                        child: Text("To Website",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blue[500])),
                                      ))
                                ])
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        height: 200,
                        color: const Color.fromARGB(227, 212, 126, 111),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20, left: 20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: [
                                      Text("Workout Quick Menu",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    spacing: 10,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (!Hive.isBoxOpen('Workout')) {
                                              await Hive.openBox('Workout');
                                            }
                                            if (!Hive.isBoxOpen('WorkoutDoc')) {
                                              await Hive.openBox('WorkoutDoc');
                                            }
                                            if (!Hive.isBoxOpen(
                                                'WorkoutSchedule')) {
                                              await Hive.openBox(
                                                  'WorkoutSchedule');
                                            }
                                            if (!Hive.isBoxOpen(
                                                'WorkoutNotes')) {
                                              await Hive.openBox(
                                                  'WorkoutNotes');
                                            }
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const WorkoutPage()))
                                                .then((value) {
                                              _closeWorkoutBoxes();
                                            });
                                          },
                                          child: const Text("Home")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (!Hive.isBoxOpen('Workout')) {
                                              await Hive.openBox('Workout');
                                            }
                                            if (!Hive.isBoxOpen('WorkoutDoc')) {
                                              await Hive.openBox('WorkoutDoc');
                                            }
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const WorkoutArchive()))
                                                .then((value) {
                                              _closeWorkoutBoxes();
                                            });
                                          },
                                          child: const Text("Document")),
                                    ]),
                              ),
                            ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        height: 200,
                        color: const Color.fromARGB(243, 3, 48, 145),
                        child: const Center(child: Text("TBA"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        height: 200,
                        color: const Color.fromARGB(243, 3, 48, 145),
                        child: const Center(child: Text("TBA"))),
                  ),
                ]),
              ),
            ),

            /*
              Navigation Bar 
            */
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //The page options at the top of the main page
                Row(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GamingHome())).then((value) {
                              _closeGameBoxes();
                            });
                          },
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Gaming'),
                            ),
                          ),
                        ),
                        if (gamingMenu)
                          SizedBox(
                            width: screenWidth * .25,
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      if (!Hive.isBoxOpen('Games')) {
                                        await Hive.openBox('Games');
                                      }
                                      if (!Hive.isBoxOpen('RecentGames')) {
                                        await Hive.openBox('RecentGames');
                                        if (Hive.box('RecentGames').isEmpty) {
                                          RecentGames data =
                                              RecentGames(recents: []);
                                          await Hive.box('RecentGames')
                                              .add(data);
                                        }
                                      }
                                      if (!Hive.isBoxOpen('GameGoals')) {
                                        await Hive.openBox('GameGoals');
                                      }

                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const GamingHome()))
                                          .then((value) {
                                        _closeGameBoxes();
                                      });
                                    },
                                    child: MouseRegion(
                                        onEnter: (event) => setState(() =>
                                            colorMap['gameListColor'] =
                                                Colors.green),
                                        onExit: (event) => setState(() =>
                                            colorMap['gameListColor'] =
                                                Colors.lightGreen),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    colorMap['gameListColor']),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            height: 40,
                                            child: const Center(
                                              child: Text("Games List"),
                                            )))),
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

                                      var recentGameBox =
                                          Hive.box('RecentGames').getAt(0);
                                      if (recentGameBox != null &&
                                          recentGameBox.recents.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GameProfile(
                                                        index: Hive.box(
                                                                'RecentGames')
                                                            .getAt(0)
                                                            .recents[0]))).then(
                                            (value) {
                                          _closeGameBoxes();
                                        });
                                      }
                                    },
                                    child: MouseRegion(
                                        onEnter: (event) => setState(() =>
                                            colorMap['recentGameColor'] =
                                                Colors.green),
                                        onExit: (event) => setState(() =>
                                            colorMap['recentGameColor'] =
                                                Colors.lightGreen),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: colorMap[
                                                    'recentGameColor']),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            height: 40,
                                            child: const Center(
                                              child: Text("Most Recent"),
                                            )))),
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
                            if (!Hive.isBoxOpen('Workout')) {
                              await Hive.openBox('Workout');
                            }
                            if (!Hive.isBoxOpen('WorkoutDoc')) {
                              await Hive.openBox('WorkoutDoc');
                            }
                            if (!Hive.isBoxOpen('WorkoutSchedule')) {
                              await Hive.openBox('WorkoutSchedule');
                            }
                            if (!Hive.isBoxOpen('WorkoutNotes')) {
                              await Hive.openBox('WorkoutNotes');
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WorkoutPage())).then((value) {
                              _closeWorkoutBoxes();
                            });
                          },
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Workout'),
                            ),
                          ),
                        ),
                        if (workoutMenu)
                          Container(
                              width: screenWidth * .25,
                              decoration:
                                  const BoxDecoration(color: Colors.lightGreen),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (!Hive.isBoxOpen('Workout')) {
                                        await Hive.openBox('Workout');
                                      }
                                      if (!Hive.isBoxOpen('WorkoutDoc')) {
                                        await Hive.openBox('WorkoutDoc');
                                      }
                                      if (!Hive.isBoxOpen('WorkoutSchedule')) {
                                        await Hive.openBox('WorkoutSchedule');
                                      }
                                      if (!Hive.isBoxOpen('WorkoutNotes')) {
                                        await Hive.openBox('WorkoutNotes');
                                      }
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WorkoutPage()))
                                          .then((value) {
                                        _closeWorkoutBoxes();
                                      });
                                    },
                                    child: MouseRegion(
                                      onEnter: (event) => setState(() =>
                                          colorMap['updateWorkoutColor'] =
                                              Colors.green),
                                      onExit: (event) => setState(() =>
                                          colorMap['updateWorkoutColor'] =
                                              Colors.lightGreen),
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: colorMap[
                                                  'updateWorkoutColor']),
                                          child: const Center(
                                            child: Text("Update Workout Info",
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!Hive.isBoxOpen('Workout')) {
                                        await Hive.openBox('Workout');
                                      }
                                      if (!Hive.isBoxOpen('WorkoutDoc')) {
                                        await Hive.openBox('WorkoutDoc');
                                      }
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WorkoutArchive()))
                                          .then((value) {
                                        _closeWorkoutBoxes();
                                      });
                                    },
                                    child: MouseRegion(
                                      onEnter: (event) => setState(() =>
                                          colorMap['viewWorkoutHistoryColor'] =
                                              Colors.green),
                                      onExit: (event) => setState(() =>
                                          colorMap['viewWorkoutHistoryColor'] =
                                              Colors.lightGreen),
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: colorMap[
                                                  'viewWorkoutHistoryColor']),
                                          child: const Center(
                                            child: Text("View History",
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!Hive.isBoxOpen('Workout')) {
                                        await Hive.openBox('Workout');
                                      }
                                      if (!Hive.isBoxOpen('WorkoutSchedule')) {
                                        await Hive.openBox('WorkoutSchedule');
                                      }
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RoutinePlanner()))
                                          .then((value) {
                                        _closeWorkoutBoxes();
                                      });
                                    },
                                    child: MouseRegion(
                                      onEnter: (event) => setState(() =>
                                          colorMap['routinePlannerColor'] =
                                              Colors.green),
                                      onExit: (event) => setState(() =>
                                          colorMap['routinePlannerColor'] =
                                              Colors.lightGreen),
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: colorMap[
                                                  'routinePlannerColor']),
                                          child: const Center(
                                            child: Text("Routine Planner",
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _orgMenu,
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Organization'),
                            ),
                          ),
                        ),
                        if (orgMenu)
                          Container(
                              width: screenWidth * .25,
                              decoration:
                                  const BoxDecoration(color: Colors.green),
                              child: const Column(
                                children: [
                                  Text("Edit/Add Events"),
                                  Text('Calendar'),
                                ],
                              )),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _funMenu,
                          child: Container(
                            width: screenWidth * .25,
                            height: 50,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text('Fun'),
                            ),
                          ),
                        ),
                        if (funMenu)
                          Container(
                              width: screenWidth * .25,
                              decoration:
                                  const BoxDecoration(color: Colors.green),
                              child: Column(
                                children: [
                                  //Solitare Menu
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Solitare()));
                                      },
                                      child: MouseRegion(
                                          onEnter: (event) => setState(() =>
                                              colorMap['solitareListColor'] =
                                                  Colors.green),
                                          onExit: (event) => setState(() =>
                                              colorMap['solitareListColor'] =
                                                  Colors.lightGreen),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: colorMap[
                                                      'solitareListColor']),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .25,
                                              height: 40,
                                              child: const Center(
                                                child: Text("Solitare"),
                                              )))),

                                  //Poker Menu
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Poker()));
                                      },
                                      child: MouseRegion(
                                          onEnter: (event) => setState(() =>
                                              colorMap['pokerListColor'] =
                                                  Colors.green),
                                          onExit: (event) => setState(() =>
                                              colorMap['pokerListColor'] =
                                                  Colors.lightGreen),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: colorMap[
                                                      'pokerListColor']),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .25,
                                              height: 40,
                                              child: const Center(
                                                child: Text("Poker"),
                                              )))),

                                  //Spinner Menu
                                  GestureDetector(
                                      onTap: () async {
                                        await Hive.openBox('SpinnerData');
                                        if (Hive.box('SpinnerData').isEmpty) {
                                          SpinnerData data = SpinnerData(
                                              items: [
                                                'Nothing yet',
                                                'Still nothing'
                                              ]);
                                          await Hive.box('SpinnerData')
                                              .add(data);
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SpinningPage()));
                                      },
                                      child: MouseRegion(
                                          onEnter: (event) => setState(() =>
                                              colorMap['gameListColor'] =
                                                  Colors.green),
                                          onExit: (event) => setState(() =>
                                              colorMap['gameListColor'] =
                                                  Colors.lightGreen),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: colorMap[
                                                      'gameListColor']),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .25,
                                              height: 40,
                                              child: const Center(
                                                child: Text("Random Wheel"),
                                              )))),

                                  //Chess Menu
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Chess()));
                                      },
                                      child: MouseRegion(
                                        onEnter: (event) => setState(() =>
                                            colorMap['chessListColor'] =
                                                Colors.green),
                                        onExit: (event) => setState(() =>
                                            colorMap['chessListColor'] =
                                                Colors.lightGreen),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  colorMap['chessListColor']),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .25,
                                          height: 40,
                                          child: const Center(
                                            child: Text("Chess"),
                                          ),
                                        ),
                                      ))
                                ],
                              )),
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
