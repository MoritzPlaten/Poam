import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:provider/provider.dart';

import '../../services/localeService/Locales.dart';
import '../PoamDropDown/PoamDropDown.dart';

class PoamOptions extends StatefulWidget {
  const PoamOptions({Key? key}) : super(key: key);

  @override
  State<PoamOptions> createState() => _PoamOptionsState();
}

class _PoamOptionsState extends State<PoamOptions> {

  late double padding;
  String languageValue = "";

  @override
  Widget build(BuildContext context) {

    ///watcher
    context.watch<Locales>().getLocale();

    ///initialize
    padding = MediaQuery.of(context).padding.top;

    if (languageValue == "") {
      languageValue = languagesAsString(context, Languages.values.first);
    }

    return Padding(
      padding: EdgeInsets.only(top: padding, right: 30, left: 30),
      child: ListView(
        shrinkWrap: true,
        children: [

          Center(
            child: Text(
              AppLocalizations.of(context)!.settings,
              style: GoogleFonts.novaMono(
                fontSize: 18
              ),
            ),
          ),

          const SizedBox(height: 30,),

          ///TODO: Change language, add in db
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Flexible(
                  child: Text(
                    "Sprache:",
                    style: GoogleFonts.novaMono(),
                  )
              ),

              const SizedBox(
                width: 20,
              ),

              Flexible(
                flex: 3,
                  child: PoamDropDown(
                    dropdownValue: languageValue,
                    onChanged: (String? value) {
                      languageValue = value!;
                    },
                    items: languagesAsListString(context),
                    color: Colors.white,
                    iconData: Icons.arrow_drop_down,
                    foregroundColor: Colors.black,
                  ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}

