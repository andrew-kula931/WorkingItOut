import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class Solitare extends StatefulWidget {
  const Solitare({super.key});

  @override
  State<Solitare> createState() => _SolitareState();
}

class _SolitareState extends State<Solitare> {

  ShapeBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    side: const BorderSide(color: Colors.black, width: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Solitare'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            height: 200,
            child: FlatCardFan(
              children: [
                PlayingCardView(
                  card: PlayingCard(Suit.hearts, CardValue.ace),
                  showBack: true,
                  elevation: 3.0,
                  shape: shape),
                PlayingCardView(
                  card: PlayingCard(Suit.hearts, CardValue.ace),
                  showBack: true,
                  elevation: 3.0,
                  shape: shape),
                PlayingCardView(
                   card: PlayingCard(Suit.hearts, CardValue.ace),
                  showBack: true,
                  elevation: 3.0,
                  shape: shape),
                PlayingCardView(
                  card: PlayingCard(Suit.hearts, CardValue.ace),
                  elevation: 3.0,
                  shape: shape)
              ]
            ),
          ),
          SizedBox(
            width: 100,
            height: 180,
            child: Stack(
              children: [
                PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.five), showBack: true),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.seven), showBack: true),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 40),
                    PlayingCardView(card: PlayingCard(Suit.spades, CardValue.king))
                  ]
                ),
              ],
            ),
            //PlayingCardView(card: PlayingCard(Suit.spades, CardValue.ace)),
          ),
        ]
      )
    );
  }
}