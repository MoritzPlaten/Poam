import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamColorPicker extends StatefulWidget {

  final Color? pickedColor;
  final Function(Color?)? onChangeColor;

  const PoamColorPicker({ Key? key, this.pickedColor, this.onChangeColor }) : super(key: key);

  @override
  _PoamColorPickerState createState() => _PoamColorPickerState();
}

class _PoamColorPickerState extends State<PoamColorPicker> {

  Color mycolor = Colors.black;

  @override
  Widget build(BuildContext context) {

    ///TODO: Change the Color of the Item

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context){
              return AlertDialog(
                title: Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: MaterialPicker(
                    pickerColor: widget.pickedColor!, //default color
                    onColorChanged: widget.onChangeColor!,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('DONE'),
                    onPressed: () {
                      Navigator.of(context).pop(); //dismiss the color picker
                    },
                  ),
                ],
              );
            });
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: widget.pickedColor!,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            child: Center(
              child: Text(
                "Farbe auswählen",
                style: GoogleFonts.novaMono(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
