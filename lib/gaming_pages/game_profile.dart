import 'package:flutter/material.dart';

class GameProfile extends StatefulWidget {
  final String title;
  const GameProfile({super.key, required this.title});

  @override
  State<GameProfile> createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
    );
  }
}