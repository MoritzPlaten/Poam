import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Objects/BartChartModel.dart';

class DateService {

  final List<BarChartModel> data = [
    BarChartModel(
      day: "Mon",
      tasks: 3,
      finishedTasks: 1,
      color: charts.ColorUtil.fromDartColor
        (const Color(0xFF47505F)),
    ),
    BarChartModel(
      day: "Tue",
      tasks: 2,
      finishedTasks: 0,
      color: charts.ColorUtil.fromDartColor
        (Colors.red),
    ),
    BarChartModel(
      day: "Wed",
      tasks: 5,
      finishedTasks: 1,
      color: charts.ColorUtil.fromDartColor
        (Colors.green),
    ),
    BarChartModel(
      day: "Thurs",
      tasks: 1,
      finishedTasks: 0,
      color: charts.ColorUtil.fromDartColor
        (Colors.yellow),
    ),
    BarChartModel(
      day: "Fr",
      tasks: 0,
      finishedTasks: 1,
      color: charts.ColorUtil.fromDartColor
        (Colors.lightBlueAccent),
    ),
    BarChartModel(
      day: "Sat",
      tasks: 3,
      finishedTasks: 0,
      color: charts.ColorUtil.fromDartColor
        (Colors.pink),
    ),
    BarChartModel(
      day: "Sun",
      tasks: 1,
      finishedTasks: 1,
      color: charts.ColorUtil.fromDartColor
        (Colors.purple),
    ),
  ];

  ///Gets the Date of the Monday in this week
  DateTime getMondayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 1));
  }

  ///Gets the Date of the Sunday in this week
  DateTime getSundayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 7));
  }

  ///Get a List of all dates
  List<String> getListOfAllDates(Iterable<dynamic> getItems) {
    List<String> dates = List.generate(getItems.length, (index) => "");
    for (int i = 0;i < dates.length; i++) {

      if (!dates.contains(getItems.elementAt(i).date)) {
        dates[i] = getItems.elementAt(i).date;
      }
    }
    for (int i = 0;i < getItems.length; i++) {
      dates.remove("");
    }

    dates.sort((a, b){ //sorting in ascending order
      return DateTime.parse(a).compareTo(DateTime.parse(b));
    });

    return dates;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

}