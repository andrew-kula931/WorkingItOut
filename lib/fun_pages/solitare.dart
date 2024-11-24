import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../fun_components/card_fan.dart';
import '../fun_components/card_stack.dart';
import '../fun_components/empty_stack.dart';

class Solitare extends StatefulWidget {
  const Solitare({super.key});

  @override
  State<Solitare> createState() => _SolitareState();
}

class _SolitareState extends State<Solitare> {

  //Variables to set up the card game
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<PlayingCard> secondDeck = [];
  List<List<PlayingCard>> playingColumns = [[], [], [], [], [], [], [], [], [], [], []];
  List<List<bool>> showingBack = [[], [], [], [], [], [], []];

  //Selecting variables
  int? selectedIndex;
  int? cardIndex;
  List<PlayingCard> changingCard = [];
  List<bool> selected = [true, true, true, true, true, true, true, true, true, true, true, true];

  @override
  void initState() {
    super.initState();
    dealCards(deck);
  }
  
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

  //Card index is specific to where in a column a card lies
  void setCardIndex(int index) {
    cardIndex = index;
  }

  void resetBorders() {
    for (int i = 0; i < selected.length; i++) {
      selected[i] = true;
    }
    setState(() {});
  }

  bool cardIsPlaceable(PlayingCard newCard) {
    bool correctSuit = false;
    bool correctNumber = false;

    //Checking suit
    if (changingCard[0].suit == Suit.diamonds || changingCard[0].suit == Suit.hearts) {
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
        if (changingCard[0].value == CardValue.two) {
          correctNumber = true;
        }
        break;
      case CardValue.four:
        if (changingCard[0].value == CardValue.three) {
          correctNumber = true;
        }
        break;
      case CardValue.five:
        if (changingCard[0].value == CardValue.four) {
          correctNumber = true;
        }
        break;
      case CardValue.six:
        if (changingCard[0].value == CardValue.five) {
          correctNumber = true;
        }
        break;
      case CardValue.seven:
        if (changingCard[0].value == CardValue.six) {
          correctNumber = true;
        }
        break;
      case CardValue.eight:
        if (changingCard[0].value == CardValue.seven) {
          correctNumber = true;
        }
        break;
      case CardValue.nine:
        if (changingCard[0].value == CardValue.eight) {
          correctNumber = true;
        }
        break;
      case CardValue.ten:
        if (changingCard[0].value == CardValue.nine) {
          correctNumber = true;
        }
        break;
      case CardValue.jack:
        if (changingCard[0].value == CardValue.ten) {
          correctNumber = true;
        }
        break;
      case CardValue.queen:
        if (changingCard[0].value == CardValue.jack) {
          correctNumber = true;
        }
        break;
      case CardValue.king:
        if (changingCard[0].value == CardValue.queen) {
          correctNumber = true;
        }
        break;
      default:
        break;
    }

    //Verifies that the card is placeable
    if (correctNumber && correctSuit) {
      return true;
    } else {
      return false;
    }
  }

  //This checks to see if a card can be added to a top stack
  bool isCardPutAtop(PlayingCard? topCard, Suit defaultSuit) {
    bool correctSuit = false;
    bool nextValue = false;

    //Makes sure that a card is selected
    if (changingCard.isEmpty) {
      return false;
    }

    //Returns true if there is no top card and the suits match
    if (topCard == null && defaultSuit == changingCard[0].suit && changingCard[0].value == CardValue.ace) {
      return true;
    }

    //If the previous did not pass and top card is still null then it's false
    if (topCard == null) {
      return false;
    }

    //Checks to see if the suits match in general
    if (defaultSuit == changingCard[0].suit) {
      correctSuit = true;
    }

    //Checks for card value
    switch (topCard.value) {
      case CardValue.ace:
        if (changingCard[0].value == CardValue.two) {
          nextValue = true;
        }
        break;
      case CardValue.two:
        if (changingCard[0].value == CardValue.three) {
          nextValue = true;
        }
        break;
      case CardValue.three:
        if (changingCard[0].value == CardValue.four) {
          nextValue = true;
        }
        break;
      case CardValue.four:
        if (changingCard[0].value == CardValue.five) {
          nextValue = true;
        }
        break;
      case CardValue.five:
        if (changingCard[0].value == CardValue.six) {
          nextValue = true;
        }
        break;
      case CardValue.six:
        if (changingCard[0].value == CardValue.seven) {
          nextValue = true;
        }
        break;
      case CardValue.seven:
        if (changingCard[0].value == CardValue.eight) {
          nextValue = true;
        }
        break;
      case CardValue.eight:
        if (changingCard[0].value == CardValue.nine) {
          nextValue = true;
        }
        break;
      case CardValue.nine:
        if (changingCard[0].value == CardValue.ten) {
          nextValue = true;
        }
        break;
      case CardValue.ten:
        if (changingCard[0].value == CardValue.jack) {
          nextValue = true;
        }
        break;
      case CardValue.jack:
        if (changingCard[0].value == CardValue.queen) {
          nextValue = true;
        }
        break;
      case CardValue.queen:
        if (changingCard[0].value == CardValue.king) {
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

  //This is the actual algorithm to place a card on a top stack
  void moveCardOnTop(PlayingCard? topCard, Suit boxSuit, List<PlayingCard> stack) {
    
    //If more than one card is selected that function breaks
    if (changingCard.length > 1 || changingCard.isEmpty) {
      return;
    }

    //If selected index is not null then it comes from a column
    if (selectedIndex != null) {
      if (isCardPutAtop(topCard, boxSuit)) {
        stack.add(playingColumns[selectedIndex!].removeLast());
        showingBack[selectedIndex!].removeLast();

        //Makes sure that the list is not empty
        if (showingBack[selectedIndex!].isNotEmpty) {
          showingBack[selectedIndex!].last = false;      
        }

        selectedIndex = null;
        changingCard = [];
      }

    //SelectedIndex is null so it comes from the secondDeck
    } else {
      if (isCardPutAtop(topCard, boxSuit)) {
        stack.add(secondDeck.removeLast());
        changingCard = [];
      }
    }

    //Update page
    selectedIndex = null;
    changingCard = [];
    resetBorders();
    setState(() {});
  }

  void moveCard(int currentIndex) {

    //Checks to see if card needs to be selected
    if (selectedIndex == null && changingCard.isEmpty) {

      //Makes sure that the column is not empty
      if (playingColumns[currentIndex].isNotEmpty) {
        selectedIndex = currentIndex;

        //Checks to see if one of the top stacks were clicked
        if (currentIndex > 6) {
          changingCard.add(playingColumns[currentIndex].last);

        //Checks to see if there is one or multiple cards
        } else if (cardIndex == null || cardIndex == playingColumns[currentIndex].length - 1) {
          changingCard.add(playingColumns[currentIndex].last);

        //This handles multiple cards selected
        } else {
          for (int i = cardIndex!; i < playingColumns[currentIndex].length; i++) {
            changingCard.add(playingColumns[currentIndex][i]);
          }
        }
      }

      resetBorders();
      selected[currentIndex] = false;

    //Checks for empty row
    } else if (playingColumns[currentIndex].isEmpty) {
      if (changingCard[0].value == CardValue.king) {
        for (PlayingCard card in changingCard) {
          playingColumns[currentIndex].add(card);
          showingBack[currentIndex].add(false);
        }

        //If selectedIndex is null it is from secondDeck otherwise updates other column
        if (selectedIndex != null) {
          for (int i = 0; i < changingCard.length; i++) {
            playingColumns[selectedIndex!].removeLast();
            showingBack[selectedIndex!].removeLast();
            showingBack[selectedIndex!].last = false;      
          }
        } else {
          secondDeck.removeLast();
        }

        changingCard = [];
        selectedIndex = null;
      }

    //Occurs if card is placeable
    } else {
      if (cardIsPlaceable(playingColumns[currentIndex].last)) {

        //Occurs if card is selected from secondDeck
        if (selectedIndex == null) {
          playingColumns[currentIndex].add(changingCard[0]);
          showingBack[currentIndex].add(false);

          secondDeck.removeLast();

          changingCard.removeLast();

        //Runs if card is being moved from the top piles
        } else if (selectedIndex! > 6) {
          playingColumns[currentIndex].add(changingCard[0]);
          showingBack[currentIndex].add(false);
          playingColumns[selectedIndex!].removeLast();

          changingCard = [];
          selectedIndex = null;

        //Runs when a card is being moved between piles after selection
        } else {
          for (PlayingCard card in changingCard) {
            playingColumns[currentIndex].add(card);
            showingBack[currentIndex].add(false);
          }
          
          for (int i = 0; i < changingCard.length; i++) {
            showingBack[selectedIndex!].removeLast();
            playingColumns[selectedIndex!].removeLast();
          }
          
          if (showingBack[selectedIndex!].isNotEmpty) {
            showingBack[selectedIndex!].last = false;
          }

          changingCard = [];
          selectedIndex = null;
        }

      //This is if the card is not placeable
      } else {
        selectedIndex = null;
        changingCard = [];
      }

      resetBorders();
    }
    setState(() {});
  }




  /*

    Widget Tree begins here

  */

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

              //Top Diamond stack
              GestureDetector(
                onTap: () {
                  if (changingCard.isNotEmpty) {
                    moveCardOnTop(playingColumns[7].isNotEmpty ? playingColumns[7].last : null, Suit.diamonds, playingColumns[7]);
                  } else {
                    moveCard(7);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: (playingColumns[7].isEmpty) ? Border.all(width: 2) : null), 
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 30,
                            child: Image.asset(
                              "assets/card_imagery/diamond.png",
                              package: 'playing_cards',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        CardStack(cards: playingColumns[7], showingBack: false, selected: selected[7]),
                      ]
                    )
                  ),
                ),
              ),

              //Top Heart Stack
              GestureDetector(
                onTap: () {
                  if (changingCard.isNotEmpty) {
                    moveCardOnTop(playingColumns[8].isNotEmpty ? playingColumns[8].last : null, Suit.hearts, playingColumns[8]);
                  } else {
                    moveCard(8);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: (playingColumns[8].isEmpty) ? Border.all(width: 2) : null), 
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 30,
                            child: Image.asset(
                              "assets/card_imagery/heart.png",
                              package: 'playing_cards',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        CardStack(cards: playingColumns[8], showingBack: false, selected: selected[8]),
                      ]
                    )
                  ),
                ),
              ),

              //Top Spades Stack
              GestureDetector(
                onTap: () {
                  if (changingCard.isNotEmpty) {
                    moveCardOnTop(playingColumns[9].isNotEmpty ? playingColumns[9].last : null, Suit.spades, playingColumns[9]);
                  } else {
                    moveCard(9);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: (playingColumns[9].isEmpty) ? Border.all(width: 2) : null), 
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 30,
                            child: Image.asset(
                              "assets/card_imagery/spade.png",
                              package: 'playing_cards',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        CardStack(cards: playingColumns[9], showingBack: false, selected: selected[9]),
                      ]
                    )
                  ),
                ),
              ),

              //Top Clubs Stack
              GestureDetector(
                onTap: () {
                  if (changingCard.isNotEmpty) {
                    moveCardOnTop(playingColumns[10].isNotEmpty ? playingColumns[10].last : null, Suit.clubs, playingColumns[10]);
                  } else {
                    moveCard(10);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: (playingColumns[10].isEmpty) ? Border.all(width: 2) : null), 
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 30,
                            child: Image.asset(
                              "assets/card_imagery/club.png",
                              package: 'playing_cards',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        CardStack(cards: playingColumns[10], showingBack: false, selected: selected[10]),
                      ]
                    )
                  ),
                ),
              ),

              //For debugging
              Column(
                children: [
                  Text('Selected index: $selectedIndex'),
                  Text('ChangingCard amount: ${changingCard.length}'),
                  Text('CardIndex: $cardIndex')
                ]
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
                height: 140 + (max(playingColumns[0].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(0);
                  },
                  child: (playingColumns[0].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[0],
                    showBack: showingBack[0],
                    selected: selected[0],
                    selectedCardIndex: setCardIndex,
                    spot: 0,
                    moveCard: moveCard,
                  ) : 
                  const EmptyStack(),
                ),
              ),

              //Second Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[1].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(1);
                  },
                  child: (playingColumns[1].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[1],
                    showBack: showingBack[1],
                    selected: selected[1],
                    selectedCardIndex: setCardIndex,
                    spot: 1,
                    moveCard: moveCard
                  ) : 
                  const EmptyStack()
                ),
              ),

              //Third Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[2].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(2);
                  },
                  child: (playingColumns[2].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[2],
                      showBack: showingBack[2],
                      selected: selected[2],
                      selectedCardIndex: setCardIndex,
                      spot: 2,
                      moveCard: moveCard
                  ) :
                  const EmptyStack()
                ),
              ),

              //Four Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[3].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(3);
                  },
                  child: (playingColumns[3].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[3],
                    showBack: showingBack[3],
                    selected: selected[3],
                    selectedCardIndex: setCardIndex,
                    spot: 3,
                    moveCard: moveCard
                  ) :
                  const EmptyStack()
                ),
              ),

              //Fifth Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[4].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(4);
                  },
                  child: (playingColumns[4].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[4],
                    showBack: showingBack[4],
                    selected: selected[4],
                    selectedCardIndex: setCardIndex,
                    spot: 4,
                    moveCard: moveCard
                  ) :
                  const EmptyStack()
                ),
              ),

              //Sixth Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[5].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(5);
                  },
                  child: (playingColumns[5].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[5],
                    showBack: showingBack[5],
                    selected: selected[5],
                    selectedCardIndex: setCardIndex,
                    spot: 5,
                    moveCard: moveCard
                  ) :
                  const EmptyStack()
                ),
              ),

              //Seventh Column
              SizedBox(
                width: 100,
                height: 140 + (max(playingColumns[6].length - 1, 0) * 20),
                child: GestureDetector(
                  onTap: () {
                    moveCard(6);
                  },
                  child: (playingColumns[6].isNotEmpty) ?
                  CardFan(
                    cards: playingColumns[6],
                    showBack: showingBack[6],
                    selected: selected[6],
                    selectedCardIndex: setCardIndex,
                    spot: 6,
                    moveCard: moveCard
                  ) :
                  const EmptyStack()
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
                        changingCard = [];
                        selectedIndex = null;
                        cardIndex = null;
                      }
                      resetBorders();
                      setState(() {});
                    },
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: (deck.isNotEmpty) ? 
                        CardStack(cards: deck, showingBack: true, selected: true,) :
                        const EmptyStack()
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Flipped Pile
                  GestureDetector(
                    onTap: () {
                      if (secondDeck.isNotEmpty) {
                        selectedIndex = null;
                        changingCard = [];
                        changingCard.add(secondDeck.last);
                        
                        resetBorders();
                        selected[11] = false;

                        setState(() {});
                      }
                    },
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: (secondDeck.isNotEmpty) ?
                        CardStack(cards: secondDeck, showingBack: false, selected: selected[11],) :
                        const EmptyStack()
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