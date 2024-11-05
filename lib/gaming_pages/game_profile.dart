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

  @override
  Widget build(BuildContext context) {
    var goalsList = Hive.box('GameGoals').values.where((x) => x.gameid == widget.index);
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
                  name: 'Goal Name',
                  gameid: widget.index
                );
                await Hive.box('GameGoals').add(data);
                setState(() {});
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
                var goal = goalsList.elementAt(index);
                return Container(

                  //Now turn this into the goal card of my dreams

                  decoration: BoxDecoration(color: Colors.orangeAccent.shade700),
                  child: Text(goal.name)
                );
              }
            ),
          ),
        ],
      )
    );
  }
}