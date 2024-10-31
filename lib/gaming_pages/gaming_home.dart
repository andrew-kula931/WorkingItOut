import 'package:flutter/material.dart';
import '../gaming_components/add_game.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/gaming_db.dart';

class GamingHome extends StatefulWidget {
  const GamingHome({super.key});

  @override
  State<GamingHome> createState() => _GamingHomeState();
}

class _GamingHomeState extends State<GamingHome> {
  var games = Hive.box('Games');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Game Plan')
        ),
      ),
      body: Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //Recently Played Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.2,
                child: const Text('Recently Played')
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text('Game One'),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(color: Colors.red),
                    child: const Text('Game Two'),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(color: Colors.yellow),
                    child: const Text('Game Three'),
                  ),
                ]
              )
            ],
          ),

          //List of Games
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context, 
                  builder: (context) {
                    return const AddGame();
                  }).then((value) {
                    setState(() {});
                  });
              },
              child: const Text('Add Game')
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text('Games', style: TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .58,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  var item = games.getAt(index);
                  return Container(
                    color: const Color.fromARGB(99, 46, 33, 129),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.name),
                          item.imageBytes != null ?
                            Expanded(
                              child: Image.memory(
                                item!.imageBytes!,
                                fit: BoxFit.contain,)
                              ) : const Text('No image'),
                        ],
                      )
                    )
                  );
                }
              )
            ),
          ),
        ],
      ),
    );
  }
}