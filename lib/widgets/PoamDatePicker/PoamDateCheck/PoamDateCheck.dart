import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnCheckListener(bool value);

class PoamDateCheck extends StatelessWidget {

  final bool? isChecked;
  final OnCheckListener? onCheckListener;

  const PoamDateCheck({ Key? key, this.isChecked, this.onCheckListener }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    Color primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          AppLocalizations.of(context)!.hideTime + ":",
          style: TextStyle(
            fontFamily: "Mona",
          ),
        ),

        Checkbox(
            value: this.isChecked,
            fillColor: MaterialStateProperty.all<Color>(primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            side: BorderSide(width: 2.5, style: BorderStyle.solid, color: primaryColor),
            onChanged: (bool? value) {
              this.onCheckListener!(value!);
            }
        ),

      ],
    );
  }
}
