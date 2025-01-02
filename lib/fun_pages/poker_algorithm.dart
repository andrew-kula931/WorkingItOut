// ignore_for_file: constant_identifier_names

import 'package:playing_cards/playing_cards.dart';
import 'dart:math';

//File state variables
class Result {
  final Decision decision;
  final double bet;

  Result(this.decision, this.bet);
}

enum Decision { CALL, FOLD, RAISE }

enum PairType { FULLHOUSE, FOUROFAKIND, THREEOFAKIND, TWOPAIR, ONEPAIR }

enum BetStanding { NONE, LOW, MEDIUM, HIGH, ALLIN }

Random random = Random();

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

bool findStraight(List<PlayingCard> cards, bool potential) {
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
      topStraightCard = straight[0]; //For royal flush
      return true;
    }

    if (potential && straight.length == 4) {
      return true;
    }
  }

  return false;
}

bool findFlush(List<PlayingCard> cards, bool potential) {
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

  if (potential &&
      (diamonds == 4 || hearts == 4 || spades == 4 || clubs == 4)) {
    return true;
  }

  return false;
}

bool findPairs(List<PlayingCard> cards, PairType type) {
  //Creates list of values
  List<int> values = [];
  for (var card in cards) {
    values.add(getCardValue(card));
  }

  //Creates amount of each card
  Map<int, int> cardMultiples = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
  for (int i = 1; i < 15; i++) {
    int amount = values.where((x) => x == i).length;
    cardMultiples[amount] = cardMultiples[amount]! + 1;
  }

  switch (type) {
    case PairType.FOUROFAKIND:
      if (cardMultiples[4]! == 1) {
        return true;
      }
    case PairType.FULLHOUSE:
      if (cardMultiples[3]! > 0 && cardMultiples[2]! > 0) {
        return true;
      }
    case PairType.THREEOFAKIND:
      if (cardMultiples[3]! > 0) {
        return true;
      }
    case PairType.TWOPAIR:
      if (cardMultiples[2]! > 1) {
        return true;
      }
    case PairType.ONEPAIR:
      if (cardMultiples[2]! == 1) {
        return true;
      }
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
  //This function gets run twice once without the hand so this first conditional checks that
  late List<PlayingCard> availableCards;
  if (handOne.suit != Suit.joker) {
    availableCards = [handOne, handTwo];
  } else {
    availableCards = [];
  }

  //Adds the rest of the cards to the list
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

  //Null check for a case when there are no cards to check
  if (availableCards.isEmpty) {
    return 0;
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
  if (findStraight(availableCards, false) &&
      findFlush(availableCards, false) &&
      topStraightCard == 14) {
    return 100;
  }

  //Straight Flush
  if (findStraight(availableCards, false) && findFlush(availableCards, false)) {
    return 99;
  }

  //Four of a Kind
  if (findPairs(availableCards, PairType.FOUROFAKIND)) {
    return 90;
  }

  //Full House
  if (findPairs(availableCards, PairType.FULLHOUSE)) {
    return 80;
  }

  //Flush
  if (findFlush(availableCards, false)) {
    return 60;
  }

  //Straight
  if (findStraight(availableCards, false)) {
    return 50;
  }

  //Three of a Kind
  if (findPairs(availableCards, PairType.THREEOFAKIND)) {
    return 40;
  }

  //Two Pair
  if (findPairs(availableCards, PairType.TWOPAIR)) {
    return 30;
  }

  //One Pair
  if (findPairs(availableCards, PairType.ONEPAIR)) {
    return 20;
  }

  //Check for possible stright or possible flush
  if (findStraight(availableCards, true) || findFlush(availableCards, true)) {
    return 20;
  }

  //If all else fails then it will return the two highest card values / 2
  List<int> cardValues = [];
  for (var card in availableCards) {
    cardValues.add(getCardValue(card));
  }
  cardValues.sort((a, b) => b.compareTo(a));
  return ((cardValues[0] + cardValues[1]) / 2).floor();
}

Result makeDecision(
    PlayingCard handOne,
    PlayingCard handTwo,
    PlayingCard? flop1,
    PlayingCard? flop2,
    PlayingCard? flop3,
    PlayingCard? turn,
    PlayingCard? river,
    double currentCash,
    double currentRoundBet,
    double pot,
    int round) {
  //Gets hand strength and adjusts it for the current round
  //Round 1 -> Starting hand
  //Round 2 -> Flop
  //Round 3 -> Turn
  //Round 4 -> River
  int handStrength =
      findHandStrength(handOne, handTwo, flop1, flop2, flop3, turn, river);
  int tableStrength = findHandStrength(
      PlayingCard(Suit.joker, CardValue.joker_1),
      PlayingCard(Suit.joker, CardValue.joker_2),
      flop1,
      flop2,
      flop3,
      turn,
      river);
  late double adjustedHand;
  switch (round) {
    case 1:
      adjustedHand = handStrength * 3.5;
      break;
    case 2:
      adjustedHand = handStrength * 1.8;
      break;
    case 3:
      adjustedHand = handStrength * 1.2;
      break;
    default:
      adjustedHand = handStrength.toDouble();
      break;
  }
  adjustedHand -= tableStrength.toDouble();

  //Checks their standing and how much is in the pot
  //This will affect how much bot bets
  final double percentOfMoney = ((pot + currentRoundBet) / currentCash);
  late BetStanding roundStakes;
  if (percentOfMoney == 0) {
    roundStakes = BetStanding.NONE;
  } else if (percentOfMoney <= .10) {
    roundStakes = BetStanding.LOW;
  } else if (percentOfMoney <= .20) {
    roundStakes = BetStanding.MEDIUM;
  } else if (percentOfMoney <= .99) {
    roundStakes = BetStanding.HIGH;
  } else {
    roundStakes = BetStanding.ALLIN;
  }

  //Generates randomness based on the bot's current handStrength
  //winChance is used to calculate their odds of winning
  late int winChance;
  if (adjustedHand > 90) {
    winChance = 100;
  } else if (adjustedHand > 50) {
    winChance = 98;
  } else if (adjustedHand > 40) {
    winChance = 95;
  } else if (adjustedHand >= 30) {
    winChance = 80;
  } else if (adjustedHand >= 20) {
    winChance = 50;
  } else {
    winChance = 30;
  }

  //This increases the betStanding
  if (winChance > 97) {
    roundStakes =
        BetStanding.values[(roundStakes.index + 1) % BetStanding.values.length];

    //This is for bounds checking as the operation above wraps
    if (roundStakes == BetStanding.NONE) {
      roundStakes = BetStanding.ALLIN;
    }
  }

  //Rolls for whether the bot will bet
  int randomChance = random.nextInt(100);
  int randomChance2 = random.nextInt(100);
  bool willBet = (randomChance <= winChance) ? true : false;
  bool stayInAnyways = (randomChance2 <= winChance) ? true : false;

  //Now runs early outs for for whether the bot folds or calls
  if (percentOfMoney > currentCash * 0.4 && winChance < 50) {
    //Autofold
    return Result(Decision.FOLD, 0);
  }

  if (!willBet && currentRoundBet == 0) {
    return Result(Decision.CALL, 0);
  }

  if (!willBet && stayInAnyways) {
    return Result(Decision.CALL, 0);
  }

  if (!willBet) {
    return Result(Decision.FOLD, 0);
  }

  //Now decides how much the bot will willing to bet
  double roundScore(double bet) {
    return (bet * 20).round() / 20;
  }

  switch (roundStakes) {
    case BetStanding.NONE:
      return Result(Decision.RAISE, 1.0);
    case BetStanding.LOW:
      return Result(Decision.RAISE, roundScore(currentCash * 0.01));
    case BetStanding.MEDIUM:
      return Result(Decision.RAISE, roundScore(currentCash * 0.05));
    case BetStanding.HIGH:
      return Result(Decision.RAISE, roundScore(currentCash * 0.15));
    case BetStanding.ALLIN:
      return Result(Decision.RAISE, currentCash);
  }
}
