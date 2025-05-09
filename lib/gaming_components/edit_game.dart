import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../data/gaming_db.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import '../gaming_pages/gaming_home.dart';

class EditGame extends StatefulWidget{
  final int index;
  const EditGame({super.key, required this.index});

  @override
  State<EditGame> createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {
  var box = Hive.box('Games');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _nameController.text = box.getAt(widget.index).name;
    _descriptionController.text = box.getAt(widget.index).description;
    _imageBytes = box.getAt(widget.index).imageBytes;
  }

  //Function for adding box info
  Future<Uint8List?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final file = result.files.single.bytes;
      //final fileName = result.files.single.name;

      if (file != null) {
        final img.Image? image = img.decodeImage(file);

        if (image != null) {
          final img.Image resizedImage = img.copyResize(image, width: 150, height: 150);

          final Uint8List resizedImageBytes = Uint8List.fromList(img.encodePng(resizedImage));
          setState(() {
            _imageBytes = resizedImageBytes;
          });
          return resizedImageBytes;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 3, 29, 85),),
      child: IntrinsicHeight( 
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickFile();
                    },

                    //Addable image slot here
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _imageBytes == null ? Container(
                        width: 180,
                        height: 180,
                        color: const Color.fromARGB(255, 196, 193, 193),
                        child: const Center( 
                          child: Text('Add Image')
                        ) 
                      ) : Image.memory(_imageBytes!),
                    )
                  )
                ],
              ),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 10,
                  minLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    //Update Game Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(223, 3, 48, 145),
                      ),
                      onPressed: () async {
                        var box = Hive.box('Games');
                        var gameData = GamesDb(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          imageBytes: _imageBytes,
                        );
                        await box.putAt(widget.index, gameData);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text('Update Game'),
                    ),

                    //Delete Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(223, 3, 48, 145),
                      ),
                      onPressed: () async {
                        var goals = Hive.box('GameGoals').values.where((goal) => (goal as GameGoals).gameid == widget.index).toList();
                        for (var obj in goals) {
                          await (obj as GameGoals).delete();
                        }

                        var recentBox = Hive.box('RecentGames');
                        var recents = recentBox.getAt(0) as RecentGames;

                        recents.recents = recents.recents.where((index) => index != widget.index).toList();

                        // Update the entire entry in the Hive box
                        await recentBox.putAt(0, recents);

                        var box = Hive.box('Games');
                        await box.deleteAt(widget.index);
                        // ignore: use_build_context_synchronously
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const GamingHome()));
                      },
                      child: const Text('Delete Game'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}