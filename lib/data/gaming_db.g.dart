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
      imageBytes: fields[2] as dynamic,
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
