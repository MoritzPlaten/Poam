import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 9)
class Alarms {

  @HiveField(0)
  List<DateTime> listOfAlarms;

  Alarms(this.listOfAlarms);

}