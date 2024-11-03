import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

part 'gaming_db.g.dart';

//flutter packages pub run build_runner build

@HiveType(typeId: 10)
class GamesDb {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late Uint8List? imageBytes;

  GamesDb({
    this.name = '',
    this.description = '',
    this.imageBytes,
  });
}

@HiveType(typeId: 11)
class RecentGames {
  @HiveField(0)
  late List<int> recents;

  RecentGames({this.recents = const []});
}