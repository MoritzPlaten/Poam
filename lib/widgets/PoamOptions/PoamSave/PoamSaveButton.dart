import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../services/localeService/Locales.dart';

class PoamSaveButton extends StatefulWidget {

  final String? language;
  final Color? color;

  const PoamSaveButton({ Key? key, this.language, this.color }) : super(key: key);

  @override
  State<PoamSaveButton> createState() => _PoamSaveButtonState();
}

class _PoamSaveButtonState extends State<PoamSaveButton> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;

  @override
  Widget build(BuildContext context) {

    ///initialize
    poamSnackbar = PoamSnackbar();
    primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: ElevatedButton(
          onPressed: () {

            Provider.of<Locales>(context, listen: false).setLocale(new Locales(widget.language!));
            ///TODO: Hier die Farbe speichern in db
            poamSnackbar.showSnackBar(context, AppLocalizations.of(context)!.messageSave, primaryColor);
          },
          child: Text(
              AppLocalizations.of(context)!.save,
            style: GoogleFonts.novaMono(
                fontSize: 18
            ),
          )
      ),
    );
  }
}
