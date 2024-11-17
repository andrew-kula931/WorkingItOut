import 'package:flutter/widgets.dart';
import 'package:playing_cards/playing_cards.dart';

class CardStack extends StatelessWidget {
  final List<PlayingCard> cards;
  final bool showingBack;

  /// Creates a flat card fan.
  const CardStack({super.key, required this.cards, required this.showingBack});

  @override
  Widget build(Object context) {
    return Stack(
      children: List.generate(
        cards.length,
        (index) => Align(
          alignment: const Alignment(0, 0),
          child: buildCard(cards[index]),
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card) {
    return PlayingCardView(card: card, showBack: showingBack, elevation: 3.0);
  }
}