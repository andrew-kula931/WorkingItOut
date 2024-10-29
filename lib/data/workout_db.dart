import 'package:hive_flutter/hive_flutter.dart';

part 'workout_db.g.dart';

//flutter packages pub run build_runner build

@HiveType(typeId: 1)
class WorkoutDb {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String workouts;

  @HiveField(2)
  late List<String>? workAreas;

  WorkoutDb({this.name = '',
    this.workouts = '',
    this.workAreas});
}

@HiveType(typeId: 2)
class WorkoutDoc {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String workouts;

  @HiveField(2)
  late List<String>? workAreas;

  @HiveField(3)
  late DateTime? day;

  WorkoutDoc({this.name = '',
    this.workouts = '',
    this.workAreas,
    this.day});
}

@HiveType(typeId: 3)
class WorkoutSchedule {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String workouts;

  @HiveField(2)
  late List<String>? workAreas;

  @HiveField(3)
  late DateTime? day;

  WorkoutSchedule({this.name = '',
    this.workouts = '',
    this.workAreas,
    this.day});
}

@HiveType(typeId: 4)
class WorkoutNotes {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String note;

  WorkoutNotes({
    this.name = '',
    this.note = '',
  });
}