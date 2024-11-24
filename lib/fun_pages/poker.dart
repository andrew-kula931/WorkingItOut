import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/empty_stack.dart';

class Poker extends StatefulWidget{
  const Poker({super.key});

  @override
  State<Poker> createState() => _PokerState();
}

class _PokerState extends State<Poker> {

  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  PlayingCard? flopOne;
  PlayingCard? flopTwo;
  PlayingCard? flopThree;
  PlayingCard? turn;
  PlayingCard? river;

  void startingGame() {
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

                
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[1], showBack: false, elevation: 3.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[2], showBack: false, elevation: 3.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[3], showBack: false, elevation: 3.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: 100,
                    child: PlayingCardView(card: deck[4], showBack: false, elevation: 3.0),
                  ),
                ),
              ]
            ),
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