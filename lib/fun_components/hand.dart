import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class Hand extends StatelessWidget{
  const Hand({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    Stack( 
      children: [
        Align(
          alignment: const Alignment(0, 0),
          child: PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.joker_1), showBack: true, elevation: 3.0)
        ),
        Align(
          alignment: const Alignment(1, 0),
          child: PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.joker_1), showBack: true, elevation: 3.0)
        ),
      ]
    );
  }
}