import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/chartServices/Objects/BartChartModel.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:poam/services/itemServices/Objects/Database.dart';
import 'package:provider/provider.dart';

typedef void UpdateSelectedChart(ChartService? chartService);

class PoamChart extends StatefulWidget {

  final UpdateSelectedChart? updateSelectedChart;

  const PoamChart({ Key? key, this.updateSelectedChart }) : super(key: key);

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

    ///TODO: https://google.github.io/charts/flutter/example/behaviors/selection_callback_example.html => selectionModels => displays values of the BarModels

    ///initialize
    size = MediaQuery.of(context).size;
    dateService = DateService();
    primaryColor = Theme.of(context).primaryColor;
    datesBetween = dateService.getDaysInBetween(dateService.getMondayDate(), dateService.getSundayDate());

    return ValueListenableBuilder(
        valueListenable: Hive.box<ChartService>(Database.ChartName).listenable(),
        builder: (context, Box<ChartService> box, widgets) {

          List<charts.Series<dynamic, String>> series = Provider.of<ChartService>(context, listen: false).getSeries(context, box.values.toList(), primaryColor);

          _onSelectionChanged(charts.SelectionModel model) {
            DateService dateService = DateService();
            List<DateTime> listOfDates = dateService.getDaysInBetween(dateService.getMondayDate(), dateService.getSundayDate());

            final selectedDate = model.selectedDatum;
            List<ChartService> charts = box.values.where((element) =>
            DateFormat.yMd(Localizations.localeOf(context).languageCode)
                .format(element.dateTime) == DateFormat.yMd(Localizations.localeOf(context).languageCode)
                .format(listOfDates.elementAt(selectedDate.first.index!))).toList();

            if (charts.isNotEmpty) {

              widget.updateSelectedChart!(charts.first);

              Future.delayed(const Duration(milliseconds: 2000), () {

                ChartService? name;
                widget.updateSelectedChart!(name);
              });
            }
          }

          return SizedBox(
            width: size.width,
            height: size.height * 0.35,
            child: Stack(
              alignment: Alignment.topRight,
              children: [

                charts.BarChart(
                  series,
                  animate: true,
                  selectionModels: [
                    new charts.SelectionModelConfig(
                      type: charts.SelectionModelType.info,
                      changedListener: _onSelectionChanged,
                    )
                  ],
                  animationDuration: Duration(seconds: 0),
                ),


              ],
            ),
          );
        }
    );
  }
}