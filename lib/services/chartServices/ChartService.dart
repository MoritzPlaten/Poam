import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:poam/services/chartServices/Objects/ChartSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:poam/services/itemServices/ItemModel.dart';
import '../dateServices/DateService.dart';
import '../itemServices/Objects/Database.dart';
import 'Objects/BartChartModel.dart';
import 'Objects/ChartModel.dart';

part 'ChartService.g.dart';

@HiveType(typeId: 5)
class ChartService extends ChangeNotifier {

  ///TODO: ChartService: if a ItemModel is checked, then the right chart must be down and the left chart must be up

  @HiveField(0)
  final int isChecked;
  @HiveField(1)
  final DateTime dateTime;

  ChartService(this.isChecked, this.dateTime);

  List<ChartService> _itemModelList = <ChartService>[];
  List<ChartService> get itemModelList => _itemModelList;

  void getCharts() async {
    final box = await Hive.openBox<ChartService>(Database.ChartName);

    _itemModelList = box.values.toList();
    notifyListeners();
  }

  List<charts.Series<dynamic, String>> getSeries(context, List<ItemModel> items, DateService dateService, List<DateTime> datesBetween, Color primaryColor) {

    ChartModel chartModel = ChartModel([
      for(int i = 0;i < datesBetween.length;i++)
        BarChartModel(
          day: dateService.displayDate(context, datesBetween.elementAt(i)),

          tasks: items.where((element) => (element.fromDate.day == datesBetween.elementAt(i).day)
              && (element.fromDate.month == datesBetween.elementAt(i).month)
              && (element.fromDate.year == datesBetween.elementAt(i).year)
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