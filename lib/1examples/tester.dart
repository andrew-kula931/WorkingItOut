import 'dart:core';

void main() {
  double num = 1.4;
  Stopwatch stopwatch1 = Stopwatch()..start();

  for (int i = 0; i < 1000000; i++) {
    int newNum = num.round();
  }

  stopwatch1.stop();
  print('Rounding time: ${stopwatch1.elapsedMilliseconds} ms');

  Stopwatch stopwatch2 = Stopwatch()..start();

  for (int i = 0; i < 1000000; i++) {
    int newNum = (num + 0.5).floor();
  }

  stopwatch2.stop();
  print('Flooring time: ${stopwatch2.elapsedMilliseconds} ms');
}
