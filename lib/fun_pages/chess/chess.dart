import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import 'chess_move_reader.dart';
import 'chat_move_retreiver.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;
  bool manualGame = true;
  LineReader reader = LineReader('lib/fun_pages/chess/chess_moves.txt');

  @override
  void initState() {
    _resetGame(false);
    super.initState();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  void _flipBoard() => setState(() => flipBoard = !flipBoard);

  //Reads the next move from a file
  void _readMove() async {
    String? line = await reader.nextMove();

    if (line == null) {
      return;
    }

    bishop.Move m = game.getMove(line)!;
    game.makeMove(m);
    setState(() => state = game.squaresState(player));
    print('${game.fen} $line');
    return;
  }

  //Allows for a manual game
  void _onMove(Move move) async {
    bool result = game.makeSquaresMove(move);
    final file = File('lib/fun_pages/chess/moves_test.txt');

    //Handles the user move and writes the move to a file
    if (result) {
      await file.writeAsString(
          '${convertMove(move.from.toString(), move.to.toString())}\n',
          mode: FileMode.append);
      setState(() => state = game.squaresState(player));
    }

    //Handles the bot move and writes the move to a file
    if (state.state == PlayState.theirTurn && !aiThinking) {
      setState(() => aiThinking = true);

      await Future.delayed(
          Duration(milliseconds: Random().nextInt(1000) + 250));

      //Generate bot move
      bishop.Move botMove = game.makeRandomMove();
      int botMoveFrom = botAdjustment(botMove.from);
      int botMoveTo = botAdjustment(botMove.to);

      //Write to file
      await file.writeAsString(
          '${convertMove(botMoveFrom.toString(), botMoveTo.toString())}\n',
          mode: FileMode.append);

      setState(() {
        aiThinking = false;
        state = game.squaresState(player);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width * .7,
              child: BoardController(
                state: flipBoard ? state.board.flipped() : state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.dart,
                moves: state.moves,
                onMove: _onMove,
                onPremove: _onMove,
                markerTheme: MarkerTheme(
                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                _resetGame;
                _readMove();
              },
              child: const Text('Auto Play'),
            ),
            OutlinedButton(
              onPressed: _resetGame,
              child: const Text('New Game'),
            ),
            IconButton(
              onPressed: _flipBoard,
              icon: const Icon(Icons.rotate_left),
            ),
            IconButton(
                onPressed: () async {
                  const prompt = 'Say hello to my program in German';
                  final geminiService = GeminiMove();
                  final response = await geminiService.sendToGemini(prompt);

                  print("Gemini Response: $response");
                },
                icon: const Icon(Icons.chat))
          ],
        ),
      ),
    );
  }
}
