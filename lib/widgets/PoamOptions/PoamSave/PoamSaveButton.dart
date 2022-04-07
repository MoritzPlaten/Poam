import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:poam/services/settingService/Settings.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../services/localeService/Locales.dart';

class PoamSaveButton extends StatelessWidget {

  final String? language;
  final Color? color;

  const PoamSaveButton({ Key? key, this.language, this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    PoamSnackbar poamSnackbar = PoamSnackbar();
    Color primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: ElevatedButton(
        onPressed: () {

          Provider.of<Locales>(context, listen: false).setLocale(new Locales(this.language!));
          Provider.of<Settings>(context, listen: false).setSettings(new Settings(ColorToHex(this.color!).value));
          poamSnackbar.showSnackBar(context, AppLocalizations.of(context)!.messageSave, primaryColor);
        },
        child: Text(
          AppLocalizations.of(context)!.save,
          style: GoogleFonts.novaMono(
            fontSize: 18,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
      ),
    );
  }
}
