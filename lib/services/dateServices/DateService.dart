import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import '../chartServices/Objects/BartChartModel.dart';

class DateService {

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
  List<DateTime> getListOfAllDates(Iterable<dynamic> getItems) {
    List<DateTime> dates = List.generate(getItems.length, (index) => DateTime(0));
    for (int i = 0;i < dates.length; i++) {

      if (!dates.contains(getItems.elementAt(i).date)) {
        dates[i] = getItems.elementAt(i).date;
      }
    }
    for (int i = 0;i < getItems.length; i++) {
      dates.remove(DateTime(0));
    }

    dates.sort((a, b){ //sorting in ascending order
      return a.compareTo(b);
    });

    return dates;
  }

  List<dynamic> sortItemsByDate(List<dynamic> items) {
    items.sort((a, b){
      return a.date.compareTo(b.date);
    });

    return items;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  String displayDate(DateTime dateTime) {
    return DateFormat.E().format(dateTime);
  }
}