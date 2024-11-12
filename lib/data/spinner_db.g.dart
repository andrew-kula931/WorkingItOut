// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpinnerDataAdapter extends TypeAdapter<SpinnerData> {
  @override
  final int typeId = 20;

  @override
  SpinnerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpinnerData(
      items: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SpinnerData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpinnerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
