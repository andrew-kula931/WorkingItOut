import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/spinner_db.dart';
import 'dart:math';

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
  final FocusNode _focusNode = FocusNode();
  final FocusNode afterItemSubmitted = FocusNode();
  final Map<int, bool> hoverMap = {};

  @override
  void initState() {
    super.initState();
    nameController.text = spinnerBox.getAt(boxIndex).name;
    _focusNode.addListener(() {
      if(_focusNode.hasFocus) {
        nameController.selection = TextSelection(baseOffset: 0, extentOffset: nameController.text.length);
      }
    });
  }

  @override dispose() {
    inputValue.dispose();
    nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void spinWheel() {
    int selectedIndex = Fortune.randomInt(0, spinnerBox.getAt(boxIndex).items.length);
    controller.add(selectedIndex);

    Future.delayed(const Duration(seconds: 4, milliseconds: 600), () {
      setState(() {
        selectedItem = spinnerBox.getAt(boxIndex).items[selectedIndex];
      });
    });
  }


  //Warning dialog to prevent the spinner from having no values
  void _showWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('You must have at least two items for the spinner.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      }
    );
  }

  //Confirmation to avoid unintended deletes
  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Spinner?'),
          content: const Text('Are you sure you want to delete this spinner?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Random Wheel'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [

          //Top tab row for individual spinners
          SizedBox(
            height: 40.0,
            width: MediaQuery.of(context).size.width * 1.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Hive.box('SpinnerData').length,
              itemBuilder: (context, index) {
                var boxAtIndex = Hive.box('SpinnerData').getAt(index);
                hoverMap.putIfAbsent(index, () => false);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    //Detect whether the tab has been clicked
                    GestureDetector(
                      onTap: () {
                        boxIndex = index;
                        nameController.clear();
                        nameController.text = spinnerBox.getAt(boxIndex).name;
                        inputValue.clear();
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(color: (boxIndex == index) ? Colors.red : Colors.green),
                        height: 40.0,
                        width: MediaQuery.of(context).size.width * .18,
                        child: MouseRegion(
                          onEnter: (event) {
                            setState(() {
                              hoverMap[index] = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              hoverMap[index] = false;
                            });
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Text(boxAtIndex.name, 
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.center)
                              ),

                              //Delete button that is only visible if user is hovering and length is not 0
                              if (spinnerBox.length > 1)
                                if (hoverMap[index]!)
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          bool shouldDelete = await _confirmDelete(context);
                                          if (shouldDelete) {
                                            await Hive.box('SpinnerData').deleteAt(index);
                                            setState(() {
                                              boxIndex = max(0, boxIndex - 1);
                                              nameController.clear();
                                              nameController.text = spinnerBox.getAt(boxIndex).name;
                                              inputValue.clear();
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                            ],
                          )
                        )
                      )
                    ),

                    //This is the add button which only displays at the end of the list
                    if (index == Hive.box('SpinnerData').length - 1)
                      IconButton(
                        onPressed: () {
                          SpinnerData data = SpinnerData(
                            items: ['Item One', 'Item Two'],
                            name: '');
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

          //Main row for all object on page
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [

                  //Title box for spinner name
                  SizedBox(
                    height: 40.0,
                    width: 200.0,
                    child: TextField(
                      controller: nameController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.center,
                      onChanged: (_) {
                        spinnerBox.getAt(boxIndex).name = nameController.text;
                        spinnerBox.getAt(boxIndex).save();
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
                      ],
                    )
                  ),
                ],
              ),

              //This is the column on the right of the screen with the items
              Container(
                color: const Color.fromARGB(206, 201, 200, 200),
                child: Column(
                  children: [

                    //These are the items
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height - 302.0),
                        child: SizedBox(
                          width: 300.0,
                          height: spinnerBox.getAt(boxIndex).items.length * 40.0,
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
                                        if (spinnerBox.getAt(boxIndex).items.length < 3) {
                                          _showWarning(context);
                                          return;
                                        } else {
                                          box.items.removeAt(index);
                                          (box as SpinnerData).save();
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(Icons.delete)
                                    )
                                  )
                                ]
                              );
                            }
                          ),
                        ),
                      )
                    ),

                    //Add new item
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40.0,
                            width: 250.0,
                            child: TextField(
                              controller: inputValue,
                              focusNode: afterItemSubmitted,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onSubmitted: (_) {
                                spinnerBox.getAt(boxIndex).items.add(inputValue.text);
                                (spinnerBox.getAt(boxIndex) as SpinnerData).save();
                                inputValue.clear();
                                FocusScope.of(context).requestFocus(afterItemSubmitted);
                                setState(() {});
                              }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: IconButton(
                              onPressed: () {
                                spinnerBox.getAt(boxIndex).items.add(inputValue.text);
                                (spinnerBox.getAt(boxIndex) as SpinnerData).save();
                                inputValue.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.add)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),

          //Just to get the content centered
          const SizedBox(height: 125.0),
        ]
      ),
    );
    
  }
}
