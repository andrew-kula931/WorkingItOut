import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../data/gaming_db.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class AddGame extends StatefulWidget {
  const AddGame({super.key});

  @override
  State<AddGame> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _imageBytes;

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
      decoration: const BoxDecoration(color:  Color.fromARGB(255, 3, 29, 85),),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                child: ElevatedButton(
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
                    await box.add(gameData);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('Add Game'),
                ),
              ),
            ],
          ),
        
    );
  }
}