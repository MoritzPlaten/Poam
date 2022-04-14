import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:poam/services/settingService/Settings.dart';
import 'package:poam/widgets/PoamOptions/PoamSave/PoamSaveButton.dart';
import 'package:provider/provider.dart';

import '../../services/localeService/Locales.dart';
import '../PoamColorPicker/PoamColorPicker.dart';
import '../PoamDropDown/PoamDropDown.dart';

class PoamOptions extends StatefulWidget {
  const PoamOptions({Key? key}) : super(key: key);

  @override
  State<PoamOptions> createState() => _PoamOptionsState();
}

class _PoamOptionsState extends State<PoamOptions> {

  late double padding;
  late Size size;
  String? languageValue;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {

    ///watcher
    context.watch<Locales>().getLocale();
    context.watch<Settings>().getSettings();

    ///initialize
    size = MediaQuery.of(context).size;
    padding = MediaQuery.of(context).padding.top;

    ///if values == null then set these
    if (languageValue == null && Provider.of<Locales>(context, listen: false).locales.length != 0) {
      languageValue = Provider.of<Locales>(context, listen: false).locales.first.locale;
    }
    if (selectedColor == null && Provider.of<Settings>(context, listen: false).settings.length != 0) {
      selectedColor = Color(Provider.of<Settings>(context, listen: false).settings.first.ColorHex);
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
                    style: TextStyle(
                        fontFamily: "Mona",
                        fontSize: 18
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                ///displays the DropDownMenu for the language
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        AppLocalizations.of(context)!.language + ":",
                        style: TextStyle(
                          fontFamily: "Mona",
                        ),
                      )),
                    Flexible(
                      flex: 3,
                      child: PoamDropDown(
                        dropdownValue: languageValue != "" && languagesAsListString(context).contains(languageValue) ? languageValue : Languages.values.first.toString(),
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

                ///displays the Color Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Flexible(
                      flex: 1,
                      child: Text(
                        AppLocalizations.of(context)!.menuColor + ":",
                        style: TextStyle(
                          fontFamily: "Mona",
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 3,
                      child: PoamColorPicker(
                        pickedColor: selectedColor != null ? selectedColor : Colors.blueAccent,
                        onChangeColor: (Color? value) {
                          selectedColor = value!;
                        },
                      ),
                    ),

                  ],
                )

              ],
            ),
          ),

          ///displays the PoamSaveButton
          PoamSaveButton(
            language: languageValue,
            color: selectedColor,
          ),

        ],
      ),
    );
  }
}