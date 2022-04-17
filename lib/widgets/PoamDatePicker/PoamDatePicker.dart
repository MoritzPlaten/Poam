import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

typedef void onFromDateListener(bool val);
typedef void onFromTimeListener(bool val);

class PoamDatePicker extends StatefulWidget {

  final String? title;
  final TextEditingController? dateController;
  final TextEditingController? timeController;
  final DateTime? fromDate;
  final DateTime? fromTime;
  ///These vars come from the second TimePicker
  final onFromDateListener? firstFromDateListener;
  final onFromTimeListener? firstFromTimeListener;
  final bool? firstFromDatePicked;
  final bool? firstFromTimePicked;
  ///These vars come from the first TimePicker
  final onFromDateListener? secondFromDateListener;
  final onFromTimeListener? secondFromTimeListener;
  final bool? secondFromDatePicked;
  final bool? secondFromTimePicked;
  final bool? EditMode;

  const PoamDatePicker({ Key? key, this.title, this.timeController, this.dateController, this.fromDate, this.fromTime, this.firstFromDateListener, this.firstFromTimeListener, this.secondFromDateListener, this.secondFromTimeListener, this.firstFromDatePicked, this.firstFromTimePicked, this.secondFromDatePicked, this.secondFromTimePicked, this.EditMode }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  late Size size;
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime(0,0,0, DateTime.now().hour, DateTime.now().minute + 1);
  late String dateTime;
  bool _firstPickedTime = false, _firstPickedDate = false, _secondPickedTime = false, _secondPickedDate = false;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    ///Update the State if the fromDate or the fromTime is picked
    if (widget.firstFromDateListener != null && widget.firstFromTimeListener != null) {

      widget.firstFromDateListener!(_firstPickedDate);
      widget.firstFromTimeListener!(_firstPickedTime);
    }

    ///Update the State if the fromDate or the fromTime is picked
    if (widget.secondFromDateListener != null && widget.secondFromTimeListener != null) {

      widget.secondFromDateListener!(_secondPickedDate);
      widget.secondFromTimeListener!(_secondPickedTime);
    }

    ///if the fromTime or the fromDate is change, then it will be set the toDate or the toTime equal the fromTime or the fromDate
    if (widget.fromDate != null && widget.fromTime != null && widget.secondFromDatePicked != null && widget.secondFromTimePicked != null) {

      DateTime updatedToDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.dateController!.text);
      DateTime updatedToTime = DateFormat.Hm(Localizations.localeOf(context).languageCode).parse(widget.timeController!.text);

      ///Date
      if (updatedToDate.isBefore(widget.fromDate!)) {
        selectedDate = widget.fromDate!;

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.fromDate!);
        });
      }

      ///Time
      if (updatedToTime.isBefore(widget.fromTime!)) {
        selectedTime = widget.fromTime!;

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.fromTime!);
        });
      }

      ///Gets the Time- and DatePicked from the first Date- and TimePicker
      _secondPickedDate = widget.secondFromDatePicked!;
      _secondPickedTime = widget.secondFromTimePicked!;
    }

    ///Gets the Time- and DatePicked from the second Date- and TimePicker
    if (widget.firstFromDatePicked != null && widget.firstFromTimePicked != null) {
      _firstPickedDate = widget.firstFromDatePicked!;
      _firstPickedTime = widget.firstFromTimePicked!;
    }

    if (widget.dateController!.text == "") {
      widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }
    if (widget.timeController!.text == "") {
      widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(selectedTime);
    }

    ///If the first or the second Date Picker is not clicked then set the Date automatically
    void setDateAutomatically() {

      SchedulerBinding.instance?.addPostFrameCallback((_) {
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.now());
      });
    }

    if (widget.EditMode == false && selectedDate.isBefore(DateTime.now()) && (_secondPickedDate == false && _firstPickedDate == false)) {

      if (widget.firstFromDatePicked != null) {

        if (widget.firstFromDatePicked == false) {

          setDateAutomatically();
        }
      } else {

        setDateAutomatically();
      }
    }

    void setTimeAutomatically() {

      DateTime now = DateTime.now();
      DateTime _now = DateTime(0, 0, 0, now.hour, now.minute + 1);

      SchedulerBinding.instance?.addPostFrameCallback((_) {
        widget.timeController!.text = DateFormat.Hm(Localizations
            .localeOf(context)
            .languageCode).format(_now);
      });
    }

    ///If the first or the second Time Picker is not clicked then set the Time automatically
    if (widget.EditMode == false && selectedTime.isBefore(DateTime.now()) && (_secondPickedTime == false && _firstPickedTime == false)) {

      if (widget.firstFromTimePicked != null) {

        if (widget.firstFromTimePicked == false) {

          setTimeAutomatically();
        }
      } else {
        setTimeAutomatically();
      }
    }

    ///Opens DatePicker
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(2015),
          lastDate: DateTime(2101));
      if (picked != null)
        selectedDate = picked;

        if (widget.secondFromDateListener == null) {
          _firstPickedDate = true;
        } else {
          _secondPickedDate = true;
        }
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }

    ///Opens TimePicker
    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
      );
      if (picked != null)
        setState(() {

          if (widget.secondFromTimeListener == null) {
            _firstPickedTime = true;
          } else {
            _secondPickedTime = true;
          }

          TimeOfDay timeOfDay = picked;
          selectedTime = DateTime(0,0,0, timeOfDay.hour, timeOfDay.minute);
          widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(selectedTime);
        });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Flexible(
          flex: 1,
          child: Text(
            widget.title!,
            style: TextStyle(
              fontFamily: "Mona",
            ),
          ),
        ),

        ///Displays DatePicker
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: "Mona",
                      fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: widget.dateController!,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.only(top: 0.0)),
                ),

              ),
            ),
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        ///Displays TimePicker
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "Mona",
                      fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                    controller: widget.timeController!,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.only(top: 0.0)),
                  ),
                ),
            ),
          ),
        ),

      ],
    );
  }
}
