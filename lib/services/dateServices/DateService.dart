class DateService {

  DateTime getMondayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 1));
  }

  DateTime getSundayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 7));
  }

}