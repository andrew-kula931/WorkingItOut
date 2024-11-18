import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class CardFan extends StatefulWidget {
  final List<PlayingCard> cards;
  final List<bool> showBack;
  final bool selected;

  /// Creates a flat card fan.
  const CardFan({super.key, required this.cards, required this.showBack, required this.selected});

  @override
  State<CardFan> createState() => _CardFanState();
}

class _CardFanState extends State<CardFan> {

  ShapeBorder blackBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.black, width: 1));

  ShapeBorder greenBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    side: const BorderSide(color: Colors.green, width: 1));

  @override
  Widget build(Object context) {
    return Stack(
      children: List.generate(
        widget.cards.length,
        (index) => Align(
          alignment: Alignment(
            0, widget.cards.length > 1
                ? -1.0 + (index / (widget.cards.length - 1)) * 2.1 : 0
          ),
          child: buildCard(widget.cards[index], widget.showBack[index]),
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card, bool isLast) {
    return 
      (widget.selected) ?
          PlayingCardView(card: card, showBack: isLast, elevation: 3.0, shape: blackBorder) :
          PlayingCardView(card: card, showBack: isLast, elevation: 3.0, shape: greenBorder);
  }
}