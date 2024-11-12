import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinningPage extends StatefulWidget {
  const SpinningPage({super.key});

  @override
  SpinningPageState createState() => SpinningPageState();
}

class SpinningPageState extends State<SpinningPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isSpinning = false;
  StreamController<int> controller = StreamController<int>();

  //Just for testing
  final List<String> names = [
    'The Long Dark',
    'Minecraft',
    'Project Zomboid',
    'Terraria',
    'Warframe',
    'Literally Anything Else'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when no longer needed
    super.dispose();
  }

  void spinWheel() {
    setState(() {
      isSpinning = !isSpinning;
      if (isSpinning) {
        _controller.forward().then((_) {
          setState(() {
            isSpinning = false;
            _controller.reset();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Random Wheel'),
      ),
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              spinWheel();
            },
            child: const Text('Spin')
          ),
          SizedBox(
            child: RotationTransition(
              turns: _controller,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Spin',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ),
          SizedBox(
            width: 400,
            height: 400,
            child: FortuneWheel(
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
              onFling: () {
                controller.add(Fortune.randomInt(0, names.length));
              },
              selected: controller.stream,
              items: [
                for (String name in names) FortuneItem(child: Text(name))

                /*
                FortuneItem(child: Text('Han Solo')),
                FortuneItem(child: Text('Yoda')),
                FortuneItem(child: Text('Obi-Wan Kenobi')),
                */
              ],
            )
          )
        ]
      ),
    );
    
  }
}
