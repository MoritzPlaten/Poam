import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamDropDown/PoamDropDown.dart';

class PoamDatePicker extends StatefulWidget {

  final int? dateValue;
  final dynamic Function(String?)? onDateChanged;
  final int? monthValue;
  final dynamic Function(String?)? onMonthChanged;

  const PoamDatePicker({Key? key, this.dateValue, this.onDateChanged, this.monthValue, this.onMonthChanged }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  ///TODO: Make it working

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("Day: "),

        PoamDropDown(
          dropdownValue: widget.dateValue.toString(),
          onChanged: widget.onDateChanged,
          color: primaryColor,
          iconData: Icons.view_day,
          items: [
            for(int i = 1;i < 32;i++) i.toString(),
          ]
        ),

        Text("Month: "),

        PoamDropDown(
            dropdownValue: widget.monthValue.toString(),
            onChanged: widget.onMonthChanged,
            color: primaryColor,
            iconData: Icons.calendar_view_month,
            items: [
              for(int i = 1;i < 13;i++) i.toString(),
            ]
        ),

      ],
    );
  }
}
