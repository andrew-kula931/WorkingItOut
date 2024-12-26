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
      expect(findStraight(playerCards), equals(true));
    });

    test('returns false when no straight exists', () {
      List<PlayingCard> playerCards = [two, four, six, eight, ten, queen, ace];
      expect(findStraight(playerCards), equals(false));
    });

    test('ignores duplicate cards and finds a straight', () {
      List<PlayingCard> playerCards = [five, five, six, seven, eight, nine];
      expect(findStraight(playerCards), equals(true));
    });
  });

  group('findFlush', () {
    test('find a flush', () {
      List<PlayingCard> playerCards = [ace, two, three, four, five, six, seven];
      expect(findFlush(playerCards), equals(true));
    });

    test('find no flush', () {
      List<PlayingCard> playerCards = [jack, nine, eight, five, six, seven];
      expect(findFlush(playerCards), equals(false));
    });

    test('find no flush bc too small', () {
      List<PlayingCard> playerCards = [seven];
      expect(findFlush(playerCards), equals(false));
    });
  });
}
