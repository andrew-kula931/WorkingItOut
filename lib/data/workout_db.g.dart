// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutDbAdapter extends TypeAdapter<WorkoutDb> {
  @override
  final int typeId = 1;

  @override
  WorkoutDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutDb(
      name: fields[0] as String,
      workouts: fields[1] as String,
      workAreas: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDb obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.workouts)
      ..writeByte(2)
      ..write(obj.workAreas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutDocAdapter extends TypeAdapter<WorkoutDoc> {
  @override
  final int typeId = 2;

  @override
  WorkoutDoc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutDoc(
      name: fields[0] as String,
      workouts: fields[1] as String,
      workAreas: (fields[2] as List?)?.cast<String>(),
      day: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDoc obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.workouts)
      ..writeByte(2)
      ..write(obj.workAreas)
      ..writeByte(3)
      ..write(obj.day);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDocAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutScheduleAdapter extends TypeAdapter<WorkoutSchedule> {
  @override
  final int typeId = 3;

  @override
  WorkoutSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSchedule(
      name: fields[0] as String,
      workouts: fields[1] as String,
      workAreas: (fields[2] as List?)?.cast<String>(),
      day: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSchedule obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.workouts)
      ..writeByte(2)
      ..write(obj.workAreas)
      ..writeByte(3)
      ..write(obj.day);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutNotesAdapter extends TypeAdapter<WorkoutNotes> {
  @override
  final int typeId = 4;

  @override
  WorkoutNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutNotes(
      name: fields[0] as String,
      note: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutNotes obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
