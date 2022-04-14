import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnCheckListener(bool value);

class PoamDateCheck extends StatelessWidget {

  final bool? value;
  final OnCheckListener? onCheckListener;

  PoamDateCheck({ Key? key, this.value, this.onCheckListener }) : super(key: key);

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {


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
            value: isChecked,
            onChanged: (bool? value) {
              this.onCheckListener!(value!);
            }
        ),

      ],
    );
  }
}
