import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PoamDatePicker extends StatefulWidget {

  final String? title;
  final String? test;
  final TextEditingController? dateController;
  final TextEditingController? timeController;

  const PoamDatePicker({ Key? key, this.title, this.test, this.dateController, this.timeController }) : super(key: key);

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
          widget.dateController!.text = DateFormat.yMd().format(selectedDate);
        });
    }

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

        Text(
          widget.title!,
          style: GoogleFonts.novaMono(),
        ),

        const SizedBox(
          width: 8,
        ),

        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextFormField(
                style: GoogleFonts.novaMono(
                    fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                enabled: false,
                controller: widget.dateController,
                onChanged: ((String? value) {
                  setState(() {
                    _setDate = value!;
                    print(value);
                  });
                }),
                decoration: InputDecoration(
                  hintText: DateFormat.yMd().format(selectedDate),
                    hintStyle: const TextStyle(color: Colors.white),
                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(top: 0.0)),
              ),

          ),
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        InkWell(
          onTap: () {
            _selectTime(context);
          },
          child: Container(
              width: 80,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextFormField(
                  style: GoogleFonts.novaMono(
                    fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: widget.timeController,
                  onChanged: ((String? value) {
                    setState(() {
                      _setTime = value!;
                      print(value);
                    });
                  }),
                  decoration: InputDecoration(
                      hintText: selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
                      hintStyle: const TextStyle(color: Colors.white),
                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(top: 0.0)),
                ),
              )
          ),
        ),
      ],
    );
  }
}
