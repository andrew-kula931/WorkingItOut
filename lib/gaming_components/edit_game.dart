import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../data/gaming_db.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class EditGame extends StatefulWidget{
  final int index;
  const EditGame({super.key, required this.index});

  @override
  State<EditGame> createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {
  var box = Hive.box('Games');

  @override
  Widget build(BuildContext context) {
    return const Text('Hello World');
  }
}