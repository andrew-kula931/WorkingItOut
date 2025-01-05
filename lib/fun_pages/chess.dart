import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  BoardState state = const BoardState(board: [
    'r',
    'n',
    'b',
    'q',
    'k',
    'b',
    'n',
    'r',
    'p',
    'p',
    'p',
    'p',
    'p',
    'p',
    'p',
    'p',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'P',
    'P',
    'P',
    'P',
    'P',
    'P',
    'P',
    'P',
    'R',
    'N',
    'B',
    'Q',
    'K',
    'B',
    'N',
    'R'
  ], turn: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess')),
      body: Center(
        child: Board(
          state: state,
          pieceSet: PieceSet.merida(),
        ),
      ),
    );
  }
}
