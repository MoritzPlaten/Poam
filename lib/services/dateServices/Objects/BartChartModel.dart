import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String? day;
  int? tasks;
  int? finishedTasks;
  final charts.Color? color;

  BarChartModel({
    this.day,
    this.tasks,
    this.finishedTasks,
    this.color,}
      );
}