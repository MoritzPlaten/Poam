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

}