import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/empty_stack.dart';
import '../fun_components/hand.dart';
import 'poker_algorithm.dart';
import 'dart:async';

class Poker extends StatefulWidget {
  const Poker({super.key});

  @override
  State<Poker> createState() => _PokerState();
}

class _PokerState extends State<Poker> {
  //Card variables
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  PlayingCard? flopOne;
  PlayingCard? flopTwo;
  PlayingCard? flopThree;
  PlayingCard? turn;
  PlayingCard? river;
  //Player is at index 0
  List<List<PlayingCard>> competitorHands = [[], [], [], [], [], [], []];

  //Player's total is at index 0
  List<double> money = [500, 500, 500, 500, 500, 500, 500];
  double pot = 0;
  double currentBet = 0;

  //Configuration variables
  int opponents = 2;
  List<int> opponentAmount = [1, 2, 3, 4, 5, 6];

  //Game variables
  bool gameHasStarted = false;
  TextEditingController raiseAmount = TextEditingController();
  int round = 0;
  List<int> folded = [];
  int callCounter = 0;

  void startingGame() {
    deck = standardFiftyTwoCardDeck();
    deck.shuffle();
    for (int i = 0; i <= opponents; i++) {
      competitorHands[i].add(deck.removeLast());
      competitorHands[i].add(deck.removeLast());
    }

    //Makes sure that all the game state variables have been reset
    folded = [];
    callCounter = 0;

    gameHasStarted = true;
  }

  void nextMove() {
    currentBet = 0;
    if (flopOne == null) {
      flopOne = deck.removeLast();
      flopTwo = deck.removeLast();
      flopThree = deck.removeLast();
    } else if (turn == null) {
      turn = deck.removeLast();
    } else {
      river ??= deck.removeLast();
    }
    round++;
    setState(() {});
  }

  Future<void> botMoves(int round) async {
    callCounter = 0;
    for (int i = 1; i <= opponents; i++) {
      if (folded.contains(i)) {
        callCounter++;
        continue;
      }

      Result botDecision = makeDecision(
          competitorHands[i][0],
          competitorHands[i][1],
          flopOne,
          flopTwo,
          flopThree,
          turn,
          river,
          money[i],
          currentBet,
          pot,
          round);

      switch (botDecision.decision) {
        case Decision.FOLD:
          print('bot $i folded');
          folded.add(i);
          callCounter++;
          break;
        case Decision.CALL:
          print('bot $i called');
          money[i] -= currentBet;
          pot += currentBet;
          callCounter++;
          break;
        case Decision.RAISE:
          print('bot $i raised ${botDecision.bet}');
          double totalMoney = currentBet + botDecision.bet;
          currentBet += botDecision.bet;
          money[i] -= totalMoney;
          pot += totalMoney;
          callCounter = 0;
          break;
      }

      //Gives a short pause between bot decisions
      setState(() {});
      await Future.delayed(const Duration(seconds: 1), () {});
    }

    //Resets counter and applies next move
    if (callCounter == opponents) {
      callCounter == 0;
      nextMove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Poker'),
          ),
        ),
        body: Stack(children: [
          Center(
            child: CustomPaint(
              size: const Size(1500, 1500),
              painter: CirclePainter(),
            ),
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Dealer Pile
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(
                        card: PlayingCard(Suit.spades, CardValue.ace),
                        showBack: true,
                        elevation: 3.0),
                  )),

              //FlopOne
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopOne != null)
                      ? SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: flopOne!, showBack: false, elevation: 3.0),
                        )
                      : const EmptyStack()),

              //FlopTwo
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopTwo != null)
                      ? SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: flopTwo!, showBack: false, elevation: 3.0),
                        )
                      : const EmptyStack()),

              //FlopThree
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopThree != null)
                      ? SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: flopThree!,
                              showBack: false,
                              elevation: 3.0),
                        )
                      : const EmptyStack()),

              //Turn
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (turn != null)
                      ? SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: turn!, showBack: false, elevation: 3.0),
                        )
                      : const EmptyStack()),

              //River
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (river != null)
                      ? SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: river!, showBack: false, elevation: 3.0),
                        )
                      : const EmptyStack()),
            ]),
          ),

          //Hands
          //CPU 1
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Align(
                alignment: const Alignment(-0.92, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 140,
                        width: 140,
                        child: (gameHasStarted)
                            ? const Hand()
                            : const Icon(Icons.person, size: 100)),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(money[1].toString())),
                  ],
                )),
          ),

          //CPU 2
          if (opponents >= 2)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: const Alignment(0.92, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 140,
                          width: 140,
                          child: (gameHasStarted)
                              ? const Hand()
                              : const Icon(Icons.person, size: 100)),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(money[2].toString())),
                    ],
                  )),
            ),

          //CPU 3
          if (opponents >= 3)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: const Alignment(-0.85, -0.82),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 140,
                          width: 140,
                          child: (gameHasStarted)
                              ? const Hand()
                              : const Icon(Icons.person, size: 100)),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(money[3].toString())),
                    ],
                  )),
            ),

          //CPU 4
          if (opponents >= 4)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: const Alignment(0.85, -0.82),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 140,
                          width: 140,
                          child: (gameHasStarted)
                              ? const Hand()
                              : const Icon(Icons.person, size: 100)),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(money[4].toString())),
                    ],
                  )),
            ),

          //CPU 5
          if (opponents >= 5)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: const Alignment(-0.85, 0.82),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 140,
                          width: 140,
                          child: (gameHasStarted)
                              ? const Hand()
                              : const Icon(Icons.person, size: 100)),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(money[5].toString())),
                    ],
                  )),
            ),

          //CPU 6
          if (opponents == 6)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: const Alignment(0.85, 0.82),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 140,
                          width: 140,
                          child: (gameHasStarted)
                              ? const Hand()
                              : const Icon(Icons.person, size: 100)),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(money[6].toString())),
                    ],
                  )),
            ),

          //Player hand
          if (gameHasStarted)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Align(
                alignment: const Alignment(0, 0.7),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: SizedBox(
                            height: 140,
                            width: 100,
                            child: PlayingCardView(
                                card: competitorHands[0][0],
                                showBack: false,
                                elevation: 3.0)),
                      ),
                      SizedBox(
                          height: 140,
                          width: 100,
                          child: PlayingCardView(
                              card: competitorHands[0][1],
                              showBack: false,
                              elevation: 3.0)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attach_money),
                      Text(money[0].toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700))
                    ],
                  )
                ]),
              ),
            ),

          //Game configuration settings
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: 50,
                      height: 30,
                      color: Colors.white,
                      child: DropdownButton<int>(
                        value: opponents,
                        items: opponentAmount.map((int amount) {
                          return DropdownMenuItem<int>(
                            value: amount,
                            child: Text(amount.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newAmount) {
                          setState(() {
                            if (newAmount != null) {
                              opponents = newAmount;
                            }
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  if (!gameHasStarted)
                    //Starting Game
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            round = 0;
                            startingGame();
                          });
                        },
                        child: const Text('Start Game')),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (gameHasStarted)

                      //Call
                      ElevatedButton(
                        onPressed: () {
                          money[0] -= currentBet;
                          pot += currentBet;
                          if (callCounter < opponents) {
                            botMoves(round);
                          } else {
                            nextMove();
                          }
                        },
                        child: const Text('Call'),
                      ),
                    if (gameHasStarted)

                      //Fold
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () {
                            //Handle game over

                            if (callCounter < opponents) {
                              botMoves(round);
                            } else {
                              nextMove();
                            }
                          },
                          child: const Text('Fold'),
                        ),
                      ),
                    if (gameHasStarted)

                      //Raise
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              pot += int.parse(raiseAmount.text);
                              money[0] -= int.parse(raiseAmount.text);
                              currentBet += int.parse(raiseAmount.text);
                              callCounter = 0;
                              setState(() {});
                              if (callCounter < opponents) {
                                botMoves(round);
                              } else {
                                nextMove();
                              }
                            },
                            child: const Text('Raise'),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 80,
                          child: TextField(
                              controller: raiseAmount,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), filled: true),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ]),
                        ),
                      ]),
                  ]),
                  if (gameHasStarted)
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text("Pot: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(pot.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text("Current Bet: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(currentBet.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                            ])
                      ],
                    )
                ],
              ),
            ),
          ]),
        ]));
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define paint properties
    final paint = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.fill;

    // Define the center and radius of the circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw the circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
