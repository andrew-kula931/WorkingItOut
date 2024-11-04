import 'package:flutter/material.dart';
import '../data/gaming_db.dart';

class GameProfile extends StatefulWidget {
  final GamesDb gameInfo;
  const GameProfile({super.key, required this.gameInfo});

  @override
  State<GameProfile> createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile> {

  @override
  Widget build(BuildContext context) {
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
          const Text('Goals'),
          SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: ListView.builder(
              itemCount: 1, //Placeholder value
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: Colors.orangeAccent.shade700),
                  child: const Text('Testing object')
                );
              }
            ),
          ),
        ],
      )
    );
  }
}