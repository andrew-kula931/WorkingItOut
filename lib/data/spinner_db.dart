import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'spinner_db.g.dart';

//flutter packages pub run build_runner build

@HiveType(typeId: 20)
class SpinnerData extends HiveObject{
  @HiveField(0)
  late List<String> items;

  SpinnerData({this.items = const []});
}