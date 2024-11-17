import 'package:flutter/widgets.dart';
import 'package:playing_cards/playing_cards.dart';

class CardFan extends StatelessWidget {
  final List<PlayingCard> cards;
  final List<bool> showBack;

  /// Creates a flat card fan.
  const CardFan({super.key, required this.cards, required this.showBack});

  @override
  Widget build(Object context) {
    return Stack(
      children: List.generate(
        cards.length,
        (index) => Align(
          alignment: Alignment(
            0, cards.length > 1
                ? -1.0 + (index / (cards.length - 1)) * 2.0 : 0
          ),
          child: buildCard(cards[index], showBack[index]),
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card, bool isLast) {
    return PlayingCardView(card: card, showBack: isLast, elevation: 3.0);
  }
}