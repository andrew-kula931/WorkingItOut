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
