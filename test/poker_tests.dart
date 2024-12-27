import "package:flutter_test/flutter_test.dart";
import 'package:workout_app/fun_pages/poker_algorithm.dart';
import "package:playing_cards/playing_cards.dart";

PlayingCard ace = PlayingCard(Suit.clubs, CardValue.ace);
PlayingCard two = PlayingCard(Suit.clubs, CardValue.two);
PlayingCard three = PlayingCard(Suit.clubs, CardValue.three);
PlayingCard four = PlayingCard(Suit.clubs, CardValue.four);
PlayingCard five = PlayingCard(Suit.clubs, CardValue.five);
PlayingCard six = PlayingCard(Suit.hearts, CardValue.six);
PlayingCard seven = PlayingCard(Suit.hearts, CardValue.seven);
PlayingCard eight = PlayingCard(Suit.spades, CardValue.eight);
PlayingCard nine = PlayingCard(Suit.spades, CardValue.nine);
PlayingCard ten = PlayingCard(Suit.diamonds, CardValue.ten);
PlayingCard jack = PlayingCard(Suit.diamonds, CardValue.jack);
PlayingCard queen = PlayingCard(Suit.clubs, CardValue.queen);
PlayingCard king = PlayingCard(Suit.clubs, CardValue.king);
void main() {
  group('findStraight', () {
    test('finds a straight with Ace as low card', () {
      List<PlayingCard> playerCards = [ace, two, three, four, five, ten, jack];
      expect(findStraight(playerCards, false), equals(true));
    });

    test('returns false when no straight exists', () {
      List<PlayingCard> playerCards = [two, four, six, eight, ten, queen, ace];
      expect(findStraight(playerCards, false), equals(false));
    });

    test('ignores duplicate cards and finds a straight', () {
      List<PlayingCard> playerCards = [five, five, six, seven, eight, nine];
      expect(findStraight(playerCards, false), equals(true));
    });
  });

  group('findFlush', () {
    test('find a flush', () {
      List<PlayingCard> playerCards = [ace, two, three, four, five, six, seven];
      expect(findFlush(playerCards, false), equals(true));
    });

    test('find no flush', () {
      List<PlayingCard> playerCards = [jack, nine, eight, five, six, seven];
      expect(findFlush(playerCards, false), equals(false));
    });

    test('find no flush bc too small', () {
      List<PlayingCard> playerCards = [seven];
      expect(findFlush(playerCards, false), equals(false));
    });
  });

  group('find card strength', () {
    test('royal flush', () {
      expect(
          findHandStrength(
              PlayingCard(Suit.clubs, CardValue.ace),
              PlayingCard(Suit.clubs, CardValue.king),
              PlayingCard(Suit.clubs, CardValue.queen),
              PlayingCard(Suit.clubs, CardValue.jack),
              PlayingCard(Suit.clubs, CardValue.ten),
              null,
              null),
          equals(100));
    });

    test('one pair', () {
      expect(
          findHandStrength(
              PlayingCard(Suit.clubs, CardValue.ace),
              PlayingCard(Suit.spades, CardValue.ace),
              PlayingCard(Suit.clubs, CardValue.queen),
              PlayingCard(Suit.hearts, CardValue.jack),
              PlayingCard(Suit.clubs, CardValue.ten),
              null,
              null),
          equals(20));
    });

    test('king, jack high', () {
      expect(
          findHandStrength(
              PlayingCard(Suit.clubs, CardValue.three),
              PlayingCard(Suit.spades, CardValue.two),
              PlayingCard(Suit.clubs, CardValue.king),
              PlayingCard(Suit.hearts, CardValue.jack),
              PlayingCard(Suit.clubs, CardValue.ten),
              null,
              null),
          equals(12));
    });

    test('queen, jack high', () {
      expect(
          findHandStrength(
              PlayingCard(Suit.clubs, CardValue.three),
              PlayingCard(Suit.spades, CardValue.two),
              PlayingCard(Suit.clubs, CardValue.queen),
              PlayingCard(Suit.hearts, CardValue.jack),
              PlayingCard(Suit.clubs, CardValue.ten),
              null,
              null),
          equals(11));
    });

    test('full house', () {
      expect(
          findHandStrength(
              PlayingCard(Suit.clubs, CardValue.three),
              PlayingCard(Suit.spades, CardValue.three),
              PlayingCard(Suit.clubs, CardValue.three),
              PlayingCard(Suit.clubs, CardValue.seven),
              PlayingCard(Suit.clubs, CardValue.seven),
              PlayingCard(Suit.hearts, CardValue.eight),
              null),
          equals(80));
    });
  });

  group('make decision', () {
    //Actual result -> Result(Decision.RAISE, 500);
    test('All in royal flush', () {
      expect(
          makeDecision(
                  PlayingCard(Suit.clubs, CardValue.ace),
                  PlayingCard(Suit.clubs, CardValue.king),
                  PlayingCard(Suit.clubs, CardValue.queen),
                  PlayingCard(Suit.clubs, CardValue.jack),
                  PlayingCard(Suit.clubs, CardValue.ten),
                  null,
                  null,
                  500,
                  260,
                  100,
                  3)
              .bet,
          equals(500));
    });

    test('Autofold', () {
      expect(
          makeDecision(
                  PlayingCard(Suit.hearts, CardValue.two),
                  PlayingCard(Suit.clubs, CardValue.seven),
                  PlayingCard(Suit.spades, CardValue.four),
                  PlayingCard(Suit.diamonds, CardValue.eight),
                  PlayingCard(Suit.clubs, CardValue.queen),
                  null,
                  null,
                  500,
                  260,
                  100,
                  3)
              .decision,
          equals(Decision.FOLD));
    });
  });
}
