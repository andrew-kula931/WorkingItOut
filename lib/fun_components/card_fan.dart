import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

typedef IntCallback = void Function(int spot);

class CardFan extends StatefulWidget {
  final List<PlayingCard> cards;
  final List<bool> showBack;
  final bool selected;
  final IntCallback selectedCardIndex;
  final int spot;
  final IntCallback moveCard;

  /// Creates a flat card fan.
  const CardFan({super.key, required this.cards, required this.showBack, required this.selected, 
    required this.selectedCardIndex, required this.spot, required this.moveCard});

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

  int selectedIndex = 100;

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
          child: buildCard(widget.cards[index], index),
        ),
      ),
    );
  }

  Widget buildCard(PlayingCard card, int index) {
    return GestureDetector(
      onTap: () {
        selectedIndex = index;
        if (widget.showBack[index]) {
          for (int i = 0; i < widget.showBack.length; i++) {
            if (!widget.showBack[i]) {
              widget.selectedCardIndex(i);
              break;
            }
          }
        } else {
          widget.selectedCardIndex(index);
        }
        widget.moveCard(widget.spot);
        setState(() {});
      },
      child: 
        (index >= selectedIndex && !widget.selected && !widget.showBack[index]) ?
          PlayingCardView(card: card, showBack: widget.showBack[index], elevation: 3.0, shape: greenBorder) :
          PlayingCardView(card: card, showBack: widget.showBack[index], elevation: 3.0, shape: blackBorder),
    );
  }
}