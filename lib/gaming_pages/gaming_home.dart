import 'package:flutter/material.dart';

class GamingHome extends StatefulWidget {
  const GamingHome({super.key});

  @override
  State<GamingHome> createState() => _GamingHomeState();
}

class _GamingHomeState extends State<GamingHome> {

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
              onPressed: () {},
              child: const Text('Add Game')
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: ListView.builder(
              itemCount: 3, //Just a placeholder
              itemBuilder: (context, index) {
                return Text('Game #$index');
              }
            )
          ),
        ],
      ),
    );
  }
}