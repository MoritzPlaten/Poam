import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Database.dart';
import 'package:provider/provider.dart';

class PoamChart extends StatefulWidget {

  const PoamChart({Key? key }) : super(key: key);

  @override
  _PoamChartState createState() => _PoamChartState();
}

class _PoamChartState extends State<PoamChart> {

  late Size size;
  late Color primaryColor;
  late DateService dateService;
  late List<DateTime> datesBetween;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    dateService = DateService();
    primaryColor = Theme.of(context).primaryColor;
    datesBetween = dateService.getDaysInBetween(dateService.getMondayDate(), dateService.getSundayDate());

    return ValueListenableBuilder(
        valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
        builder: (context, Box box, widget) {
          return SizedBox(
            width: size.width,
            height: 250,
            child: charts.BarChart(Provider.of<ChartService>(context, listen: false).getSeries(box.values.where((element) => element.categories == Categories.tasks).toList(), dateService, datesBetween, primaryColor), animate: true,),
          );
        }
    );
  }
}