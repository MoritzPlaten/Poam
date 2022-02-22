import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PoamDatePicker extends StatefulWidget {

  final TextEditingController? dateController;
  final TextEditingController? timeController;

  const PoamDatePicker({ Key? key, this.dateController, this.timeController }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  late Size size;
  late String _hour, _minute, _time;
  late String _setTime, _setDate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  late String dateTime;
  ///TODO: Make it working

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

        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            width: 150,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                style: GoogleFonts.novaMono(
                    fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                enabled: false,
                keyboardType: TextInputType.text,
                controller: widget.dateController,
                onChanged: ((String? value) {
                  setState(() {
                    _setDate = value!;
                    print(value);
                  });
                }),
                decoration: InputDecoration(
                  hintText: "Datum: " + DateFormat.yMd().format(selectedDate),
                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(top: 0.0)),
              ),
            )
          ),
        ),

        InkWell(
          onTap: () {
            _selectTime(context);
          },
          child: Container(
              width: 100,
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  style: GoogleFonts.novaMono(
                    fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: widget.timeController,
                  onChanged: ((String? value) {
                    setState(() {
                      _setTime = value!;
                      print(value);
                    });
                  }),
                  decoration: InputDecoration(
                      hintText: "Zeit: " + selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
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
