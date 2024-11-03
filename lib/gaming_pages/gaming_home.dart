import 'package:flutter/material.dart';
import '../gaming_components/add_game.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'game_profile.dart';

class GamingHome extends StatefulWidget {
  const GamingHome({super.key});

  @override
  State<GamingHome> createState() => _GamingHomeState();
}

class _GamingHomeState extends State<GamingHome> {
  var games = Hive.box('Games');
  var recentsBox = Hive.box('RecentGames');

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
                height: 175,
                width: MediaQuery.of(context).size.width * 0.2,
                child: const Center(
                  child: Text('Recently Played', style: TextStyle(fontSize: 20)))
              ),
              
              //Dynamic list of recently played games
              SizedBox(
                width: 500,
                height: 175,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentsBox.getAt(0).recents.length,
                  itemBuilder: (context, index) {
                    var recentGame = games.getAt(recentsBox.getAt(0).recents[index]);
                    return Container(
                      color: const Color.fromARGB(99, 46, 33, 129),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(recentGame.name),
                            recentGame.imageBytes != null ?
                              Image.memory(
                                recentGame!.imageBytes!,
                                fit: BoxFit.contain,)
                              : const Text('No image'),
                          ],
                        )
                      )
                    );
                  }
                ),
              ),
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
                  return GestureDetector(
                    onTap: () async {
                      var recent = recentsBox.getAt(0);
                      if (recent.recents.length < 3) {
                        recent.recents.insert(0, index);
                      } else {
                        if (!recent.recents.contains(index)) {
                          recent.recents.remove(recent.recents[2]);
                          recent.recents.insert(0, index);
                        }
                      }
                      //Save changes
                      await recentsBox.putAt(0, recent);
                      // ignore: use_build_context_synchronously
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GameProfile(gameInfo: item)))
                      .then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
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