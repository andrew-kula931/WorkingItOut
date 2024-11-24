import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/empty_stack.dart';
import '../fun_components/hand.dart';

class Poker extends StatefulWidget{
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
  List<List<PlayingCard>>? competitorHands;

  //Configuration variables
  int? opponents = 2;
  List<int> opponentAmount = [1, 2, 3, 4, 5, 6];

  void startingGame() {
    deck = standardFiftyTwoCardDeck();
    deck.shuffle();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Poker'),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: CustomPaint(
              size: const Size(1500, 1500),
              painter: CirclePainter(),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Dealer Pile
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: PlayingCard(Suit.spades, CardValue.ace), showBack: true, elevation: 3.0),
                  )
                ),

                //FlopOne
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopOne != null) ? SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[0], showBack: false, elevation: 3.0),
                  ) :
                  const EmptyStack()
                ),

                //FlopTwo
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopTwo != null) ? SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[1], showBack: false, elevation: 3.0),
                  ) :
                  const EmptyStack()
                ),

                //FlopThree
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (flopThree != null) ? SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[2], showBack: false, elevation: 3.0),
                  ) :
                  const EmptyStack()
                ),

                //Turn
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (turn != null) ? SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[3], showBack: false, elevation: 3.0),
                  ) :
                  const EmptyStack()
                ),

                //River
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: (river != null) ? SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[4], showBack: false, elevation: 3.0),
                  ) :
                  const EmptyStack()
                ),
              ]
            ),
          ),

          const SizedBox(
            height: 140,
            width: 140,
            child: Align(
              alignment: Alignment(-0.5, 0),
              child: Hand()
            ),
          ),


          //Game configuration settings
          Row(
            children: [
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
                              opponents = newAmount;
                            });
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                    
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: const Text('Initiate Flop')
                    ),
                  ],
                ),
              ),
            ]
          ),
        ]
      )
    );
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