import 'package:flutter/cupertino.dart';
import 'package:poam/services/chartServices/Objects/ChartSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../dateServices/DateService.dart';
import 'Objects/BartChartModel.dart';
import 'Objects/ChartModel.dart';

class ChartService extends ChangeNotifier {

  List<charts.Series<dynamic, String>> getSeries(List<dynamic> items, DateService dateService, List<DateTime> datesBetween, Color primaryColor) {

    ChartModel chartModel = ChartModel([
      for(int i = 0;i < datesBetween.length;i++)
        BarChartModel(
          day: dateService.displayDate(datesBetween.elementAt(i)),

          tasks: items.where((element) => (element.date.day == datesBetween.elementAt(i).day)
              && (element.date.month == datesBetween.elementAt(i).month)
              && (element.date.year == datesBetween.elementAt(i).year)
          ).length,

          finishedTasks: 1,
        ),
    ]);

    ChartSeries chartSeries = ChartSeries([
      charts.Series(
          id: "Tasks",
          data: chartModel.barChartModels,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.tasks,
          colorFn: (BarChartModel series, _) => charts.ColorUtil.fromDartColor(primaryColor)),
      charts.Series(
          id: "Tasks Done",
          data: chartModel.barChartModels,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.tasks,
          colorFn: (BarChartModel series, _) => charts.ColorUtil.fromDartColor(primaryColor.withGreen(240))),
    ]);
    return chartSeries.series;
  }

}