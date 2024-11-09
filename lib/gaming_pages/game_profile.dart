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
    crossedOutSubpoints = goalsList.map((goal) => goal.checkValues).toList();
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
      goal.checkValues = crossedOutSubpoints[index];
      goal.save();
    });
  }


  @override
  Widget build(BuildContext context) {
    var goalsList = Hive.box('GameGoals').values.where((x) => (x).gameid == widget.index).toList();
    return Scaffold (
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(223, 3, 48, 145),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.transparent,
              height: 1,
              width: 1),
            Text(widget.gameInfo.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),   
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                //Add edit menu here
              }
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          //Top Row with the Game image
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Text(widget.gameInfo.description, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
                if (widget.gameInfo.imageBytes != null)
                  Image.memory(widget.gameInfo.imageBytes!),
              ],
            ),
          ),

          //Add game button
          Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(223, 3, 48, 145),
              ),
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
          const Text('Goals', style: TextStyle(color: Colors.white)),

          //List of goals
          SizedBox(
            height: MediaQuery.of(context).size.height * .68,
            child: ListView.builder(
              itemCount: goalsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 10, right: 10),
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromARGB(209, 4, 13, 141)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              //Name textfield
                              SizedBox(
                                width: 400,
                                child: TextField(
                                  controller: nameControllers[index],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder(),),
                                  onChanged:(value) {
                                    updateGoal(index);
                                  },
                                ),
                              ),

                              //Delete goal button
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 30.0),
                                onPressed:() async {
                                  GameGoals removedGoal = goalsList.removeAt(index);
                                  await removedGoal.delete();
                                  refreshGoals();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),

                        //Description textfield
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          width: 500,
                          child: TextField(
                            controller: descriptionControllers[index],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'About Goal', border: OutlineInputBorder()),
                            onChanged:(value) {
                              updateGoal(index);
                            }
                          ),
                        ),

                        //Subpoints
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
                          child: SizedBox(
                            height: subpointsControllers[index].length * 48,
                            width: 600,
                            child: ListView.builder(
                              itemCount: subpointsControllers[index].length,
                              itemBuilder: (context, innerIndex) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [

                                        //Checkbox for subpoint
                                        IconButton(
                                          icon: Icon(
                                            crossedOutSubpoints[index][innerIndex]
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                            color: crossedOutSubpoints[index][innerIndex]
                                              ? Colors.lightGreen
                                              : Colors.grey,
                                            size: 25.0
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              crossedOutSubpoints[index][innerIndex] = 
                                                !crossedOutSubpoints[index][innerIndex];
                                            });
                                          } 
                                        ),

                                        //Subpoint textfield
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * .7,
                                          child: TextField(
                                            controller: subpointsControllers[index][innerIndex],
                                            style: TextStyle(decoration: crossedOutSubpoints[index][innerIndex]
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                              color: Colors.white),
                                            decoration: const InputDecoration(border: InputBorder.none),
                                            onChanged: (value) {
                                              updateGoal(index);
                                            }
                                          ),
                                        ),

                                        //Delete subpoint button
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.grey, size: 20.0),
                                          onPressed: () {
                                            subpointsControllers[index].removeAt(innerIndex);
                                            crossedOutSubpoints[index].removeAt(innerIndex);
                                            updateGoal(index);
                                          }
                                        ),
                                      ],
                                    ),
                                  ]
                                );
                              }
                            ),
                          ),
                        ),

                        //Add subpoint button
                        IconButton(
                          onPressed: () {
                            subpointsControllers[index]
                              .add(TextEditingController(text: ''));
                            crossedOutSubpoints[index].add(false);
                            updateGoal(index);
                            refreshGoals();
                          },
                          tooltip: 'New Subpoint',
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    )
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