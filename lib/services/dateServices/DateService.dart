import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/itemServices/ItemModel.dart';

class DateService extends ChangeNotifier {

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
  List<DateTime> getListOfAllDates(Iterable<ItemModel> getItems) {
    List<DateTime> dates = List.generate(getItems.length, (index) => DateTime(0));
    for (int i = 0;i < dates.length; i++) {

      DateTime getDate = getItems.elementAt(i).fromDate;
      DateTime YMD = DateTime(getDate.year, getDate.month, getDate.day);

      if (!dates.contains(YMD)) {
        dates[i] = YMD;
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

  List<ItemModel> sortItemsByDate(List<ItemModel> items) {
    items.sort((a, b){
      DateTime getDateTime_A = DateTime(a.fromDate.year, a.fromDate.month, a.fromDate.day, a.fromTime.hour, a.fromTime.minute);
      DateTime getDateTime_B = DateTime(b.fromDate.year, b.fromDate.month, b.fromDate.day, b.fromTime.hour, b.fromTime.minute);

      return getDateTime_A.compareTo(getDateTime_B);
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