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

    return SizedBox(
      width: size.width,
      height: 250,
      child: charts.BarChart(Provider.of<ChartService>(context, listen: false).getSeries(items, dateService, datesBetween, primaryColor), animate: true,),
    );
  }
}