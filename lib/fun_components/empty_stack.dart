import "package:flutter/material.dart";

class EmptyStack extends StatelessWidget {
  const EmptyStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 2)),
    );
  }
}