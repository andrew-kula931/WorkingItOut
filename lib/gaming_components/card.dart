import 'package:flutter/material.dart';

class PlayingCard extends StatelessWidget {
  const PlayingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.red,
      child: const Column(
        children: [
          Center(
            child: Text('Hi World')
          )
        ],
      )
    );
  }
}