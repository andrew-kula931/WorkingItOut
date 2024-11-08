import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/gaming_db.dart';

class GameProfile extends StatefulWidget {
  final GamesDb gameInfo;
  final int index;
  const GameProfile({super.key, required this.gameInfo, required this.index});

  @override
  State<GameProfile> createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile> {
  late List<GameGoals> goalsList;
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> descriptionControllers;
  late List<List<TextEditingController>> subpointsControllers;
  late List<List<bool>> crossedOutSubpoints;

  @override
  void initState() {
    super.initState();
    refreshGoals();
  }

  void refreshGoals() {
    goalsList = Hive.box('GameGoals').values
      .where((x) => (x as GameGoals).gameid == widget.index)
      .cast<GameGoals>()
      .toList();

    nameControllers = goalsList.map((goal) => TextEditingController(text: goal.name)).toList(); 
    descriptionControllers = goalsList.map((goal) => TextEditingController(text: goal.description)).toList(); 
    subpointsControllers = goalsList.map((goal) { 
      return goal.subpoints.map((text) => TextEditingController(text: text)).toList();
    }).toList(); 
    crossedOutSubpoints = goalsList.map((goal) => List.filled(goal.subpoints.length, false)).toList();
  }

  @override 
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in descriptionControllers) {
      controller.dispose();
    }
    for (var subpoints in subpointsControllers) {
      for (var controller in subpoints) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void updateGoal(int index) {
    setState(() {
      var goal = goalsList[index];
      goal.name = nameControllers[index].text;
      goal.description = descriptionControllers[index].text;
      goal.subpoints = subpointsControllers[index].map((controller) => controller.text).toList();
      goal.save();
    });
  }


  @override
  Widget build(BuildContext context) {
    var goalsList = Hive.box('GameGoals').values.where((x) => (x).gameid == widget.index).toList();
    return Scaffold (
      appBar: AppBar(
        title: Center(
          child: Text(widget.gameInfo.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Text(widget.gameInfo.description, style: const TextStyle(fontSize: 18)),
                ),
                if (widget.gameInfo.imageBytes != null)
                  Image.memory(widget.gameInfo.imageBytes!),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              onPressed: () async {
                var data = GameGoals (
                  name: '',
                  gameid: widget.index
                );
                var box = Hive.box('GameGoals');
                await box.add(data);
                await box.close();
                await Hive.openBox('GameGoals');
                
                setState(() {
                  refreshGoals();
                });
              },
              child: const Text('Add Goal')
            )
          ),
          const Text('Goals'),
          SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: ListView.builder(
              itemCount: goalsList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: Colors.orangeAccent.shade700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: nameControllers[index],
                          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                          onChanged:(value) {
                            updateGoal(index);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: TextField(
                          controller: descriptionControllers[index],
                          decoration: const InputDecoration(labelText: 'About Goal', border: OutlineInputBorder()),
                          onChanged:(value) {
                            updateGoal(index);
                          }
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
                        child: SizedBox(
                          height: 200,
                          width: 600,
                          child: ListView.builder(
                            itemCount: subpointsControllers[index].length,
                            itemBuilder: (context, innerIndex) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          crossedOutSubpoints[index][innerIndex]
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                          color: crossedOutSubpoints[index][innerIndex]
                                            ? Colors.lightGreen
                                            : Colors.grey,
                                          size: 30.0
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            crossedOutSubpoints[index][innerIndex] = 
                                              !crossedOutSubpoints[index][innerIndex];
                                          });
                                        } 
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * .7,
                                        child: TextField(
                                          controller: subpointsControllers[index][innerIndex],
                                          decoration: const InputDecoration(),
                                          onChanged: (value) {
                                            updateGoal(index);
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                ]
                              );
                            }
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          subpointsControllers[index]
                            .add(TextEditingController(text: ''));
                          goalsList[index].subpoints.add('');
                          updateGoal(index);
                          refreshGoals();
                        },
                        tooltip: 'New Subpoint',
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
                );
              }
            ),
          ),
        ],
      )
    );
  }
}