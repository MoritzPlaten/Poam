import 'package:flutter/material.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../services/dateServices/Objects/BartChartModel.dart';

class PoamChart extends StatefulWidget {
  const PoamChart({Key? key}) : super(key: key);

  @override
  _PoamChartState createState() => _PoamChartState();
}

class _PoamChartState extends State<PoamChart> {

  late DateService dateService;

  @override
  Widget build(BuildContext context) {

    dateService = DateService();
    final size = MediaQuery.of(context).size;

    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: dateService.data,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.tasks,
          colorFn: (BarChartModel series, _) => series.color!),
    ];

    return Container(
      width: size.width,
      height: 250,
      child: charts.BarChart(series, animate: true,),
    );
  }
}
