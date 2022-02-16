import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/chartServices/Objects/ChartModel.dart';
import 'package:poam/services/chartServices/Objects/ChartSeries.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import '../../services/chartServices/Objects/BartChartModel.dart';
import '../../services/itemServices/MenuService.dart';

class PoamChart extends StatefulWidget {

  const PoamChart({Key? key }) : super(key: key);

  @override
  _PoamChartState createState() => _PoamChartState();
}

class _PoamChartState extends State<PoamChart> {

  late Color primaryColor;
  late DateService dateService;
  late List<DateTime> datesBetween;
  late List<dynamic> items;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    dateService = DateService();
    primaryColor = Theme.of(context).primaryColor;
    datesBetween = dateService.getDaysInBetween(dateService.getMondayDate(), dateService.getSundayDate());
    items = Provider.of<MenuService>(context).getItems;

    ///TODO: The chart should update

    /*ChartModel chartModel = ChartModel([
      for(int i = 0;i < datesBetween.length;i++)
        BarChartModel(
          day: dateService.displayDate(datesBetween.elementAt(i)),

          tasks: items.where((element) => (element.date.day == datesBetween.elementAt(i).day)
              && (element.date.month == datesBetween.elementAt(i).month)
              && (element.date.year == datesBetween.elementAt(i).year)
          ).length,

          finishedTasks: 1,
          color: charts.ColorUtil.fromDartColor
            (primaryColor),
        ),
    ]);

    ChartSeries chartSeries = ChartSeries([
      charts.Series(
          id: "Tasks",
          data: chartModel.barChartModels,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.tasks,
          colorFn: (BarChartModel series, _) => series.color!),
    ]);*/

    return SizedBox(
      width: size.width,
      height: 250,
      child: charts.BarChart(Provider.of<ChartService>(context, listen: false).getSeries(items, dateService, datesBetween, primaryColor), animate: true,),
    );
  }
}
