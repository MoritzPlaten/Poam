import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:poam/widgets/PoamOptions/PoamSave/PoamSaveButton.dart';
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
  late Size size;
  String languageValue = "";

  @override
  Widget build(BuildContext context) {
    ///watcher
    context.watch<Locales>().getLocale();

    ///initialize
    size = MediaQuery.of(context).size;
    padding = MediaQuery.of(context).padding.top;

    if (languageValue == "" && Provider.of<Locales>(context, listen: false).locales.length != 0) {
      languageValue = Provider.of<Locales>(context, listen: false).locales.first.locale;
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          Container(
            padding: EdgeInsets.only(top: padding, right: 30, left: 30),
            height: size.height,

            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.settings,
                    style: GoogleFonts.novaMono(fontSize: 18),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.language + ":",
                          style: GoogleFonts.novaMono(),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 3,
                      child: PoamDropDown(
                        dropdownValue: languageValue != "" && languagesAsListString(context).contains(languageValue) ? languageValue : languagesAsString(context, Languages.values.first),
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

                ///TODO: Add a Color Picker to change the primaryColor

              ],
            ),
          ),

          PoamSaveButton(
            language: languageValue,
          ),

        ],
      ),
    );
  }
}
