import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:poam/services/dateServices/DateService.dart';

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

    return Container(
      height: 200,
      width: size.width,
      child: Center(child: Text("Chart"),),
    );
  }
}
