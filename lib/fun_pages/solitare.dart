import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/card_fan.dart';
import '../fun_components/card_stack.dart';

class Solitare extends StatefulWidget {
  const Solitare({super.key});

  @override
  State<Solitare> createState() => _SolitareState();
}

class _SolitareState extends State<Solitare> {

  //Variables to set up the card game
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<PlayingCard> secondDeck = [];
  List<List<PlayingCard>> playingColumns = [[], [], [], [], [], [], []];
  List<List<bool>> showingBack = [[], [], [], [], [], [], []];
  List<PlayingCard> diamondsStack = [];
  List<PlayingCard> heartsStack = [];
  List<PlayingCard> spadesStack = [];
  List<PlayingCard> clubsStack = [];

  //Selecting variables
  int? selectedIndex;
  PlayingCard? changingCard;
  List<bool> selected = [true, true, true, true, true, true, true, true];

  void dealCards(List<PlayingCard> deck) {
    // Ensure the deck is shuffled
    deck.shuffle();

    // Distribute cards
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        playingColumns[j].add(deck.removeLast());
        showingBack[j].add((i == j) ? false : true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dealCards(deck);
  }

  void resetBorders() {
    for (int i = 0; i < selected.length; i++) {
      selected[i] = true;
    }
  }

  bool cardIsPlaceable(PlayingCard newCard) {
    bool correctSuit = false;
    bool correctNumber = false;

    //Checking suit
    if (changingCard?.suit == Suit.diamonds || changingCard?.suit == Suit.hearts) {
      if (newCard.suit == Suit.spades || newCard.suit == Suit.clubs) {
        correctSuit = true;
      }
    } else {
      if (newCard.suit == Suit.diamonds || newCard.suit == Suit.hearts) {
        correctSuit = true;
      }
    }

    //Checking number
    switch (newCard.value) {
      case CardValue.three:
        if (changingCard?.value == CardValue.two) {
          correctNumber = true;
        }
        break;
      case CardValue.four:
        if (changingCard?.value == CardValue.three) {
          correctNumber = true;
        }
        break;
      case CardValue.five:
        if (changingCard?.value == CardValue.four) {
          correctNumber = true;
        }
        break;
      case CardValue.six:
        if (changingCard?.value == CardValue.five) {
          correctNumber = true;
        }
        break;
      case CardValue.seven:
        if (changingCard?.value == CardValue.six) {
          correctNumber = true;
        }
        break;
      case CardValue.eight:
        if (changingCard?.value == CardValue.seven) {
          correctNumber = true;
        }
        break;
      case CardValue.nine:
        if (changingCard?.value == CardValue.eight) {
          correctNumber = true;
        }
        break;
      case CardValue.ten:
        if (changingCard?.value == CardValue.nine) {
          correctNumber = true;
        }
        break;
      case CardValue.jack:
        if (changingCard?.value == CardValue.ten) {
          correctNumber = true;
        }
        break;
      case CardValue.queen:
        if (changingCard?.value == CardValue.jack) {
          correctNumber = true;
        }
        break;
      case CardValue.king:
        if (changingCard?.value == CardValue.queen) {
          correctNumber = true;
        }
        break;
      default:
        break;
    }

    if (correctNumber && correctSuit) {
      return true;
    } else {
      return false;
    }
  }

  bool isCardPutAtop(PlayingCard? topCard, Suit defaultSuit) {
    bool correctSuit = false;
    bool nextValue = false;

    //Makes sure that a card is selected
    if (changingCard == null) {
      return false;
    }

    //Returns true if there is no top card and the suits match
    if (topCard == null && defaultSuit == changingCard!.suit && changingCard!.value == CardValue.ace) {
      return true;
    }

    //If the previous did not pass and top card is still null then it's false
    if (topCard == null) {
      return false;
    }

    //Checks to see if the suits match in general
    if (topCard.suit == changingCard!.suit) {
      correctSuit = true;
    }

    switch (topCard.value) {
      case CardValue.ace:
        if (changingCard!.value == CardValue.two) {
          nextValue = true;
        }
        break;
      case CardValue.two:
        if (changingCard!.value == CardValue.three) {
          nextValue = true;
        }
        break;
      case CardValue.three:
        if (changingCard!.value == CardValue.four) {
          nextValue = true;
        }
        break;
      case CardValue.four:
        if (changingCard!.value == CardValue.five) {
          nextValue = true;
        }
        break;
      case CardValue.five:
        if (changingCard!.value == CardValue.six) {
          nextValue = true;
        }
        break;
      case CardValue.six:
        if (changingCard!.value == CardValue.seven) {
          nextValue = true;
        }
        break;
      case CardValue.seven:
        if (changingCard!.value == CardValue.eight) {
          nextValue = true;
        }
        break;
      case CardValue.eight:
        if (changingCard!.value == CardValue.nine) {
          nextValue = true;
        }
        break;
      case CardValue.nine:
        if (changingCard!.value == CardValue.ten) {
          nextValue = true;
        }
        break;
      case CardValue.ten:
        if (changingCard!.value == CardValue.jack) {
          nextValue = true;
        }
        break;
      case CardValue.jack:
        if (changingCard!.value == CardValue.queen) {
          nextValue = true;
        }
        break;
      case CardValue.queen:
        if (changingCard!.value == CardValue.king) {
          nextValue = true;
        }
        break;
      default:
        nextValue = false;
    }

    if (correctSuit && nextValue) {
      return true;
    } else {
      return false;
    }
  }

  void moveCardOnTop(PlayingCard? topCard, Suit boxSuit, List<PlayingCard> stack) {
    if (selectedIndex != null) {
      if (isCardPutAtop(topCard, boxSuit)) {
        stack.add(playingColumns[selectedIndex!].removeLast());
      }
    }
    setState(() {});
  }

  void moveCard(int currentIndex) {

    //Checks to see if card needs to be selected
    if (selectedIndex == null && changingCard == null) {

      //Makes sure that the column is not empty
      if (playingColumns[currentIndex].isNotEmpty) {
        selectedIndex = currentIndex;
        changingCard = playingColumns[currentIndex].last;
      }

      resetBorders();
      selected[currentIndex] = false;

    //Occurs if card placeable
    } else {
      if (cardIsPlaceable(playingColumns[currentIndex].last)) {
        //Occurs if card is selected from secondDeck
        if (selectedIndex == null) {
          playingColumns[currentIndex].add(changingCard!);
          showingBack[currentIndex].add(false);

          secondDeck.removeLast();

          changingCard = null;

        //Runs when a card is being moved between piles after selection
        } else {
          playingColumns[currentIndex].add(changingCard!);
          showingBack[currentIndex].add(false);
          
          showingBack[selectedIndex!].removeLast();
          if (showingBack[selectedIndex!].isNotEmpty) {
            showingBack[selectedIndex!].last = false;
          }
          playingColumns[selectedIndex!].removeLast();

          changingCard = null;
          selectedIndex = null;
        }

      //This is if the card is not placeable
      } else {
        selectedIndex = null;
        changingCard = null;
      }

      resetBorders();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Solitare'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  moveCardOnTop(diamondsStack.last, Suit.diamonds, diamondsStack);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    color: Colors.red,
                    child: CardStack(cards: diamondsStack, showingBack: false, selected: true),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  moveCardOnTop(heartsStack.last, Suit.hearts, heartsStack);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    color: Colors.red,
                    child: CardStack(cards: heartsStack, showingBack: false, selected: true),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  moveCardOnTop(spadesStack.last, Suit.spades, spadesStack);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    color: Colors.red,
                    child: CardStack(cards: spadesStack, showingBack: false, selected: true),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  moveCardOnTop(clubsStack.last, Suit.clubs, clubsStack);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    color: Colors.red,
                    child: CardStack(cards: clubsStack, showingBack: false, selected: true),
                  ),
                ),
              ),
            ],
          ),

          //Spacing
          const SizedBox(height: 30),

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
                    moveCard(0);
                  },
                  child: (playingColumns[0].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[0],
                    showBack: showingBack[0],
                    selected: selected[0],
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
                    moveCard(1);
                  },
                  child: (playingColumns[1].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[1],
                    showBack: showingBack[1],
                    selected: selected[1],
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
                child: GestureDetector(
                  onTap: () {
                    moveCard(2);
                  },
                  child: (playingColumns[2].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[2],
                      showBack: showingBack[2],
                      selected: selected[2],
                  ) :
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Four Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[3].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(3);
                  },
                  child: (playingColumns[3].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[3],
                    showBack: showingBack[3],
                    selected: selected[3],
                  ) :
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Fifth Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[4].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(4);
                  },
                  child: (playingColumns[4].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[4],
                    showBack: showingBack[4],
                    selected: selected[4],
                  ) :
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Sixth Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[5].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(5);
                  },
                  child: (playingColumns[5].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[5],
                    showBack: showingBack[5],
                    selected: selected[5],
                  ) :
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Seventh Column
              SizedBox(
                width: 100,
                height: 140 + ((playingColumns[6].length - 1) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(6);
                  },
                  child: (playingColumns[6].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[6],
                    showBack: showingBack[6],
                    selected: selected[6],
                  ) :
                  Container(
                    width: 100,
                    height: 120,
                    color: Colors.red,
                  ),
                ),
              ),

              //Spacing
              const SizedBox(
                width: 50
              ),

              //Discard piles
              Column(
                children: [

                  //Card pile
                  GestureDetector(
                    onTap: () {
                      if (deck.isNotEmpty) {
                        secondDeck.add(deck.removeLast());
                      }
                      setState(() {});
                    },
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: (deck.isNotEmpty) ? 
                        CardStack(cards: deck, showingBack: true, selected: true,) :
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                        )
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Flipped Pile
                  GestureDetector(
                    onTap: () {
                      if (secondDeck.isNotEmpty) {
                        selectedIndex = null;
                        changingCard = secondDeck.last;
                        
                        resetBorders();
                        selected[7] = false;

                        setState(() {});
                      }
                    },
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: (secondDeck.isNotEmpty) ?
                        CardStack(cards: secondDeck, showingBack: false, selected: selected[7],) :
                        Container(
                          width: 100,
                          height: 140,
                          color: Colors.red
                        )
                    ),
                  ),

                  if (deck.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          int secondLength = secondDeck.length;
                          for (int i = 0; i < secondLength; i++) {
                            deck.add(secondDeck.removeLast());
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.redo),
                      ),
                    ),

                ],
              ),
            ],
          ),
        ]
      )
    );
  }
}