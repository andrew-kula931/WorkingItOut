// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GamesDbAdapter extends TypeAdapter<GamesDb> {
  @override
  final int typeId = 10;

  @override
  GamesDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GamesDb(
      name: fields[0] as String,
      description: fields[1] as String,
      imageBytes: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, GamesDb obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamesDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecentGamesAdapter extends TypeAdapter<RecentGames> {
  @override
  final int typeId = 11;

  @override
  RecentGames read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentGames(
      recents: (fields[0] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecentGames obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentGamesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameGoalsAdapter extends TypeAdapter<GameGoals> {
  @override
  final int typeId = 12;

  @override
  GameGoals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameGoals(
      name: fields[0] as String,
      description: fields[1] as String,
      subpoints: (fields[2] as List).cast<String>(),
      gameid: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameGoals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.subpoints)
      ..writeByte(3)
      ..write(obj.gameid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameGoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
