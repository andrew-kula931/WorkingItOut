import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LineReader {
  late StreamIterator<String> _iterator;
  late Stream<List<int>> _stream;

  LineReader(String filePath) {
    _stream = File('lib/fun_pages/chess/chess_moves.txt').openRead();
    _iterator = StreamIterator(
        _stream.transform(utf8.decoder).transform(const LineSplitter()));
  }

  Future<String?> nextMove() async {
    if (await _iterator.moveNext()) {
      return _iterator.current;
    }
    close();
    return null;
  }

  void reset() {
    _stream = File('lib/fun_pages/chess/chess_moves.txt').openRead();
    _iterator = StreamIterator(
        _stream.transform(utf8.decoder).transform(const LineSplitter()));
  }

  void close() {
    _iterator.cancel();
  }

  void testFileReading() async {
    File file = File('lib/fun_pages/chess/chess_moves.txt');
    String content = await file.readAsString();
    print(content); // Prints the entire content of the file
  }
}

String convertMove(String from, String to) {
  String switchToSans(int input) {
    switch (input) {
      case 0:
        return 'a8';
      case 1:
        return 'b8';
      case 2:
        return 'c8';
      case 3:
        return 'd8';
      case 4:
        return 'e8';
      case 5:
        return 'f8';
      case 6:
        return 'g8';
      case 7:
        return 'h8';
      case 8:
        return 'a7';
      case 9:
        return 'b7';
      case 10:
        return 'c7';
      case 11:
        return 'd7';
      case 12:
        return 'e7';
      case 13:
        return 'f7';
      case 14:
        return 'g7';
      case 15:
        return 'h7';
      case 16:
        return 'a6';
      case 17:
        return 'b6';
      case 18:
        return 'c6';
      case 19:
        return 'd6';
      case 20:
        return 'e6';
      case 21:
        return 'f6';
      case 22:
        return 'g6';
      case 23:
        return 'h6';
      case 24:
        return 'a5';
      case 25:
        return 'b5';
      case 26:
        return 'c5';
      case 27:
        return 'd5';
      case 28:
        return 'e5';
      case 29:
        return 'f5';
      case 30:
        return 'g5';
      case 31:
        return 'h5';
      case 32:
        return 'a4';
      case 33:
        return 'b4';
      case 34:
        return 'c4';
      case 35:
        return 'd4';
      case 36:
        return 'e4';
      case 37:
        return 'f4';
      case 38:
        return 'g4';
      case 39:
        return 'h4';
      case 40:
        return 'a3';
      case 41:
        return 'b3';
      case 42:
        return 'c3';
      case 43:
        return 'd3';
      case 44:
        return 'e3';
      case 45:
        return 'f3';
      case 46:
        return 'g3';
      case 47:
        return 'h3';
      case 48:
        return 'a2';
      case 49:
        return 'b2';
      case 50:
        return 'c2';
      case 51:
        return 'd2';
      case 52:
        return 'e2';
      case 53:
        return 'f2';
      case 54:
        return 'g2';
      case 55:
        return 'h2';
      case 56:
        return 'a1';
      case 57:
        return 'b1';
      case 58:
        return 'c1';
      case 59:
        return 'd1';
      case 60:
        return 'e1';
      case 61:
        return 'f1';
      case 62:
        return 'g1';
      case 63:
        return 'h1';
      default:
        return 'Invalid input';
    }
  }

  String innerFrom = switchToSans(int.parse(from));
  String innerTo = switchToSans(int.parse(to));
  return '$innerFrom$innerTo';
}

int botAdjustment(int num) {
  if (num < 8) {
    return num;
  } else if (num < 24) {
    return num - 8;
  } else if (num < 40) {
    return num - 16;
  } else if (num < 56) {
    return num - 24;
  } else if (num < 72) {
    return num - 32;
  } else if (num < 88) {
    return num - 40;
  } else if (num < 104) {
    return num - 48;
  } else {
    return num - 56;
  }
}

class StreamLines {
  Stream<String> readFileLineByLine(String filePath) async* {
    try {
      final file = File(filePath);

      // Open the file as a stream
      Stream<String> lines = file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      // Yield each line to the caller
      await for (final line in lines) {
        yield line;
      }
    } catch (e) {
      yield 'Error reading file: $e';
    }
  }
}
