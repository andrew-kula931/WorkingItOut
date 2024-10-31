import 'package:flutter/material.dart';

class AddGame extends StatefulWidget {
  const AddGame({super.key});

  @override
  State<AddGame> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight (
      child: SizedBox (
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 75,
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}