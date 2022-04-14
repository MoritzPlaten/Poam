import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoamColorPicker extends StatelessWidget {

  final Color? pickedColor;
  final Function(Color?)? onChangeColor;

  const PoamColorPicker({Key? key, this.pickedColor, this.onChangeColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {

          showDialog(
              context: context,
              builder: (BuildContext context) {

                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.colorField),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: this.pickedColor!, //default color
                      onColorChanged: this.onChangeColor!,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.done),
                      onPressed: () {
                        Navigator.of(context).pop(); //dismiss the color picker
                      },
                    ),
                  ],
                );
              });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: this.pickedColor!,
          child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.colorField,
                  style: TextStyle(
                      fontFamily: "Mona",
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

