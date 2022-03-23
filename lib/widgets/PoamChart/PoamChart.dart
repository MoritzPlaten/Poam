import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/chartServices/Objects/BartChartModel.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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

    ///TODO: if Frequency is not single, but weekly or ..., then display the item weekly or ...
    ///TODO: https://google.github.io/charts/flutter/example/behaviors/selection_callback_example.html => selectionModels => displays values of the BarModels

    ///initialize
    size = MediaQuery.of(context).size;
    dateService = DateService();
    primaryColor = Theme.of(context).primaryColor;
    datesBetween = dateService.getDaysInBetween(dateService.getMondayDate(), dateService.getSundayDate());

    return ValueListenableBuilder(
        valueListenable: Hive.box<ChartService>(Database.ChartName).listenable(),
        builder: (context, Box<ChartService> box, widget) {

          return SizedBox(
            width: size.width,
            height: size.height * 0.35,
            child: FutureBuilder(
              future: Provider.of<ChartService>(context, listen: false).getSeries(context, box.values.toList(), ThemeMode.system == ThemeData.light() ? primaryColor : Colors.white),
              builder: (BuildContext context, AsyncSnapshot<List<charts.Series<dynamic, String>>> snapshot) {

                if (snapshot.hasData) {

                  return charts.BarChart(snapshot.data!, animate: true,);
                }

                return Center(
                  child: Text("Wird geladen"),
                );
              }
            ),
          );
        }
    );
  }
}