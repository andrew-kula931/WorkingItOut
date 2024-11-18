import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class CardStack extends StatefulWidget {
  final List<PlayingCard> cards;
  final bool showingBack;
  final bool selected;

  /// Creates a flat card fan.
  const CardStack({super.key, required this.cards, required this.showingBack, required this.selected});

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
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
          alignment: const Alignment(0, 0),
          child: buildCard(widget.cards[index]),
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card) {
    return 
      (widget.selected) ?
        PlayingCardView(card: card, showBack: widget.showingBack, elevation: 3.0, shape: blackBorder) :
        PlayingCardView(card: card, showBack: widget.showingBack, elevation: 3.0, shape: greenBorder);
  }
}