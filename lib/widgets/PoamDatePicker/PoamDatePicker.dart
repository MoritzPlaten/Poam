import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PoamDatePicker extends StatefulWidget {

  final String? title;
  final String? test;
  final TextEditingController? dateController;
  final TextEditingController? timeController;
  final TextEditingController? fromDateController;
  final TextEditingController? fromTimeController;

  const PoamDatePicker({ Key? key, this.title, this.test, this.dateController, this.timeController, this.fromTimeController, this.fromDateController }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  late Size size;
  late String _hour, _minute, _time;
  late String _setTime, _setDate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 1);
  late String dateTime;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    ///Opens DatePicker
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(2015),
          lastDate: DateTime(2101));
      if (picked != null)
        setState(() {
          selectedDate = picked;
          widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
        });
    }

    ///TODO: if the first date is selected, then set the second date equals the first date
    /*if (widget.fromDateController != null && widget.fromTimeController != null && widget.fromDateController!.text != "" && widget.fromTimeController!.text != "" && widget.dateController!.text != "" && widget.timeController!.text != "") {

      print(widget.fromDateController!.text);
      DateTime fromDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.fromDateController!.text);
      DateTime fromTime = DateTime.parse(widget.fromTimeController!.text);

      DateTime toDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.dateController!.text);
      DateTime toTime = DateTime.parse(widget.timeController!.text);

      if (toDate.compareTo(fromDate) < 0) {
        print(fromDate);
      }
    }*/

    ///Opens TimePicker
    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null)
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ' : ' + _minute;
          widget.timeController!.text = _time;
        });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Flexible(
          flex: 1,
            child: Text(
              widget.title!,
              style: GoogleFonts.novaMono(),
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
                    style: GoogleFonts.novaMono(
                        fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                    controller: widget.dateController,
                    onChanged: ((String? value) {
                      _setDate = value!;
                    }),
                    decoration: InputDecoration(
                        hintText: DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate),
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
                      style: GoogleFonts.novaMono(
                        fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      enabled: false,
                      controller: widget.timeController,
                      onChanged: ((String? value) {
                        _setTime = value!;
                      }),
                      decoration: InputDecoration(
                          hintText: selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
                          hintStyle: const TextStyle(color: Colors.white),
                          disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.only(top: 0.0)),
                    ),
                  )
              ),
            ),
        ),

      ],
    );
  }
}
