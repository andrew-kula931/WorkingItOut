import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/card_fan.dart';

class Solitare extends StatefulWidget {
  const Solitare({super.key});

  @override
  State<Solitare> createState() => _SolitareState();
}

class _SolitareState extends State<Solitare> {

  //Variables to set up the card game
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<List<PlayingCard>> playingColumns = [[], [], [], [], [], [], []];
  List<List<bool>> showingBack = [[], [], [], [], [], [], []];

  //Selecting variables
  int? selectedIndex;
  PlayingCard? changingCard;

  ShapeBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    side: const BorderSide(color: Colors.black, width: 1));

  void dealCards(List<PlayingCard> deck) {
    // Ensure the deck is shuffled
    deck.shuffle();

    // Distribute cards
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        switch (j) {
          case 0:
            playingColumns[0].add(deck.removeLast());
            showingBack[0].add(false);
            break;
          case 1:
            playingColumns[1].add(deck.removeLast());
            showingBack[1].add((i == 1) ? false : true);
            break;
          case 2:
            playingColumns[2].add(deck.removeLast());
            showingBack[2].add((i == 2) ? false : true);
            break;
          case 3:
            playingColumns[3].add(deck.removeLast());
            showingBack[3].add((i == 3) ? false : true);
            break;
          case 4:
            playingColumns[4].add(deck.removeLast());
            showingBack[4].add((i == 4) ? false : true);
            break;
          case 5:
            playingColumns[5].add(deck.removeLast());
            showingBack[5].add((i == 5) ? false : true);
            break;
          case 6:
            playingColumns[6].add(deck.removeLast());
            showingBack[6].add((i == 6) ? false : true);
            break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dealCards(deck);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Solitare'),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //First Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[0].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndex == null || changingCard == null) {
                      if (playingColumns[0].isNotEmpty) {
                        selectedIndex = 0;
                        changingCard = playingColumns[0].last;
                      }
                    } else {
                      playingColumns[0].add(changingCard!);
                      showingBack[0].add(false);
                      
                      showingBack[selectedIndex!].removeLast();
                      if (showingBack[selectedIndex!].isNotEmpty) {
                        showingBack[selectedIndex!].last = false;
                      }
                      playingColumns[selectedIndex!].removeLast();

                      changingCard = null;
                      selectedIndex = null;
                    }
                    setState(() {});
                  },
                  child: (playingColumns[0].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[0],
                    showBack: showingBack[0],
                  ) : 
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Second Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[1].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndex == null || changingCard == null) {
                      if (playingColumns[1].isNotEmpty) {
                        selectedIndex = 1;
                        changingCard = playingColumns[1].last;
                      }
                    } else {
                      playingColumns[1].add(changingCard!);
                      showingBack[1].add(false);

                      showingBack[selectedIndex!].removeLast();
                      if (showingBack[selectedIndex!].isNotEmpty) {
                        showingBack[selectedIndex!].last = false;
                      }
                      playingColumns[selectedIndex!].removeLast();

                      changingCard = null;
                      selectedIndex = null;
                    }
                    setState(() {});
                  },
                  child: (playingColumns[1].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[1],
                    showBack: showingBack[1],
                  ) : 
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Third Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[2].length - 1) * 20),
                child: CardFan(
                  cards: playingColumns[2],
                    showBack: showingBack[2],
                ),
              ),

              //Four Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[3].length - 1) * 20),
                child: CardFan(
                  cards: playingColumns[3],
                    showBack: showingBack[3],
                ),
              ),

              //Fifth Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[4].length - 1) * 20),
                child: CardFan(
                  cards: playingColumns[4],
                    showBack: showingBack[4],
                ),
              ),

              //Sixth Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[5].length - 1) * 20),
                child: CardFan(
                  cards: playingColumns[5],
                    showBack: showingBack[5],
                ),
              ),

              //Seventh Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[6].length - 1) * 20),
                child: CardFan(
                  cards: playingColumns[6],
                    showBack: showingBack[6],
                ),
              ),
            ],
          ),

          /*
          SizedBox(
            width: 100,
            height: 240,
            child: CardFan(
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
          */
        ]
      )
    );
  }
}