import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/spinner_db.dart';

class SpinningPage extends StatefulWidget {
  const SpinningPage({super.key});

  @override
  SpinningPageState createState() => SpinningPageState();
}

class SpinningPageState extends State<SpinningPage> with SingleTickerProviderStateMixin {
  StreamController<int> controller = StreamController<int>.broadcast();
  TextEditingController inputValue = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var spinnerBox = Hive.box('SpinnerData');
  int boxIndex = 0;
  String selectedItem = '';

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
  }

  //No dispose method just yet

  void spinWheel() {
    int selectedIndex = Fortune.randomInt(0, spinnerBox.getAt(boxIndex).items.length);
    controller.add(selectedIndex);

    Future.delayed(const Duration(seconds: 4, milliseconds: 600), () {
      setState(() {
        selectedItem = spinnerBox.getAt(boxIndex).items[selectedIndex];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Random Wheel'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: 
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Hive.box('SpinnerData').length,
              itemBuilder: (context, index) {
                var boxAtIndex = Hive.box('SpinnerData').getAt(boxIndex);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        boxIndex = index;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(color: (boxIndex == index) ? Colors.red : Colors.green),
                        height: 40,
                        width: 120,
                        child: Center(
                          child: Text(boxAtIndex.name, style: const TextStyle(color: Colors.black))
                        )
                      )
                    ),
                    if (index == Hive.box('SpinnerData').length - 1)
                      IconButton(
                        onPressed: () {
                          SpinnerData data = SpinnerData(
                            items: ['Item One', 'Item Two'],
                            name: 'Untitled');
                          Hive.box('SpinnerData').add(data);
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                      )
                  ]
                );
              }
            )
          ),

          SizedBox(
            height: 40,
            width: 200,
            child: TextField(
              controller: nameController,
              onChanged: (_) {
                spinnerBox.getAt(boxIndex).name = nameController.text;
                setState(() {});
              }
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(selectedItem.isEmpty ? 'Spin the wheel!' : 'Winner: $selectedItem',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ),

          //This is the actual spinner
          SizedBox(
            width: MediaQuery.of(context).size.height * .4,
            height: MediaQuery.of(context).size.height * .4,
            child: FortuneWheel(
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
              onFling: () {
                spinWheel();
              },
              selected: controller.stream,
              items: [
                for (String item in spinnerBox.getAt(boxIndex).items) FortuneItem(child: Text(item))

                //for (String name in names) FortuneItem(child: Text(name))

                /*
                FortuneItem(child: Text('Han Solo')),
                FortuneItem(child: Text('Yoda')),
                FortuneItem(child: Text('Obi-Wan Kenobi')),
                */
              ],
            )
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 300,
              height: 150,
              child: ListView.builder(
                itemCount: spinnerBox.getAt(boxIndex).items.length,
                itemBuilder: (context, index) {
                  var box = spinnerBox.getAt(boxIndex);
                  return Row(
                    children: [
                      Text(spinnerBox.getAt(boxIndex).items[index]),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: IconButton(
                          onPressed: () {
                            box.items.removeAt(index);
                            (box as SpinnerData).save();
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete)
                        )
                      )
                    ]
                  );
                }
              ),
            ),
          ),

          //Add new item
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 250,
                  child: TextField(
                    controller: inputValue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: IconButton(
                    onPressed: () {
                      spinnerBox.getAt(boxIndex).items.add(inputValue.text);
                      (spinnerBox.getAt(boxIndex) as SpinnerData).save();
                      setState(() {});
                    },
                    icon: const Icon(Icons.add)
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
    
  }
}
