import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/workout_db.dart';
import 'wnotes_list.dart';

class WorkoutNotesClass extends StatefulWidget {
  final int index;
  final Box notesList;
  const WorkoutNotesClass({super.key, required this.index, required this.notesList});

  @override
  State<WorkoutNotesClass> createState() => _WorkoutNotesClassState();
}

class _WorkoutNotesClassState extends State<WorkoutNotesClass> {
  TextEditingController _textField = TextEditingController();
  TextEditingController _notesField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if(widget.index >= 0) {
      var workoutNote = Hive.box('WorkoutNotes').getAt(widget.index);
      setState(() {
        _textField = TextEditingController(text: workoutNote.name ?? '');
        _notesField = TextEditingController(text: workoutNote.note ?? '');
      });
    } else {
      setState(() {
        _textField = TextEditingController(text: '');
        _notesField = TextEditingController(text: '');
      });
    }
  }

  @override dispose() {
    _textField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return IntrinsicHeight(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Notes', style: TextStyle(fontSize: 20)),],
          ),
          // ignore: sized_box_for_whitespace
          Container(
            padding: const EdgeInsets.all(4),
            width: screenWidth,
            child: TextField(
              controller: _textField,
              decoration: const InputDecoration(labelText: 'Name of Note', border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            width: screenWidth,
            child: TextField(
              controller: _notesField,
              decoration: const InputDecoration(labelText: 'Add Note', border: OutlineInputBorder()),
              maxLines: 20,
              minLines: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if(widget.index >= 0) {
                      var box = Hive.box('WorkoutNotes').getAt(widget.index);
                      box.name = _textField;
                      box.note = _notesField;
                    } else {
                      var changedBox = Hive.box('WorkoutNotes');
                      WorkoutNotes data = WorkoutNotes(
                        name: _textField.text,
                        note: _notesField.text,
                      );
                      await changedBox.add(data);
                    }
                    
                    //Get rid of old bottom sheet
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);

                    //Open new one
                    showModalBottomSheet(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) {
                        return WNotesList(notesList: widget.notesList);
                      }
                    );
                  }, 
                  child: const Text('Save')
                ),
                if (widget.index >= 0)
                  ElevatedButton(
                    onPressed: () async {
                      var badBox = Hive.box('WorkoutNotes');
                      badBox.deleteAt(widget.index);

                      //Get rid of current bottom sheet
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);

                      //Open new one
                      showModalBottomSheet(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) {
                        return WNotesList(notesList: widget.notesList);
                      }
                    );
                    },
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}