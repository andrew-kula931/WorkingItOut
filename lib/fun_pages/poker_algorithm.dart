// ignore_for_file: constant_identifier_names

/*
  Takes in parameters:
    Card in hand 1
    Card in hand 2
    Flop 1?
    Flop 2?
    Flop 3?
    Turn?
    River?
    Current round bet
    Total bet

  Outputs
    Decision (Call, Fold)
    Bet amount?


*/

import 'package:playing_cards/playing_cards.dart';

//File state variables
class Result {
  final Decision decision;
  final int bet;

  Result(this.decision, this.bet);
}

enum Decision { CALL, FOLD, RAISE }

late int topCard;
late int topStraightCard;

//Operations
int getCardValue(PlayingCard card) {
  switch (card.value) {
    case CardValue.two:
      return 2;
    case CardValue.three:
      return 3;
    case CardValue.four:
      return 4;
    case CardValue.five:
      return 5;
    case CardValue.six:
      return 6;
    case CardValue.seven:
      return 7;
    case CardValue.eight:
      return 8;
    case CardValue.nine:
      return 9;
    case CardValue.ten:
      return 10;
    case CardValue.jack:
      return 11;
    case CardValue.queen:
      return 12;
    case CardValue.king:
      return 13;
    case CardValue.ace:
      return 14;
    default:
      return 0;
  }
}

bool findStraight(List<PlayingCard> cards) {
  List<int> values = [];

  for (var card in cards) {
    values.add(getCardValue(card));
  }

  //Sorts in decending order, removes repeats, and covers for the ace
  //TopCard is a global variable for later use
  values.sort((a, b) => b.compareTo(a));
  topCard = values[0];
  values = values.toSet().toList();
  if (values.contains(14)) {
    values.add(1);
  }

  //Checks for a straight
  //topStraightCard is used when checking for royal flush
  List<int> straight = [];
  for (int i = 0; i < values.length; i++) {
    if (straight.isEmpty || values[i] == straight.last - 1) {
      straight.add(values[i]);
    } else if (values[i] != straight.last) {
      straight = [values[i]];
    }

    if (straight.length == 5) {
      topStraightCard = straight[0];
      return true;
    }
  }

  return false;
}

bool findFlush(List<PlayingCard> cards) {
  int diamonds = 0;
  int hearts = 0;
  int spades = 0;
  int clubs = 0;

  //Find card suits and add them to the totals
  for (var card in cards) {
    switch (card.suit) {
      case Suit.diamonds:
        diamonds++;
        break;
      case Suit.hearts:
        hearts++;
        break;
      case Suit.spades:
        spades++;
        break;
      case Suit.clubs:
        clubs++;
        break;
      default:
        break;
    }
  }

  if (diamonds >= 5 || hearts >= 5 || spades >= 5 || clubs >= 5) {
    return true;
  }

  return false;
}

int findHandStrength(
    PlayingCard handOne,
    PlayingCard handTwo,
    PlayingCard? flop1,
    PlayingCard? flop2,
    PlayingCard? flop3,
    PlayingCard? turn,
    PlayingCard? river) {
  //Build lists of available cards
  List<PlayingCard> availableCards = [handOne, handTwo];
  if (flop1 != null) {
    availableCards.add(flop1);
  }
  if (flop2 != null) {
    availableCards.add(flop2);
  }
  if (flop3 != null) {
    availableCards.add(flop3);
  }
  if (turn != null) {
    availableCards.add(turn);
  }
  if (river != null) {
    availableCards.add(river);
  }

  //Check possible hand score starting from highest possible score
  //Royal Flush 100 -> 100% of victory
  //Straight Flush 99
  //Four of a kind 90
  //Full house 80
  //Flush 60
  //Straight 50
  //Three-of-a-kind 40
  //Two pair 30
  //Pair 20
  //All else CardValue / 2

  //Royal Flush
  if (findStraight(availableCards) &&
      findFlush(availableCards) &&
      topStraightCard == 14) {
    return 100;
  }

  //Straight Flush
  if (findStraight(availableCards) && findFlush(availableCards)) {
    return 99;
  }

  //Four of a kind

  return 1;
}

Result makeDecision(
    PlayingCard handOne,
    PlayingCard handTwo,
    PlayingCard? flop1,
    PlayingCard? flop2,
    PlayingCard? flop3,
    PlayingCard? turn,
    PlayingCard? river,
    double currentRoundBet,
    double totalBet) {
  return Result(Decision.FOLD, 0);
}
