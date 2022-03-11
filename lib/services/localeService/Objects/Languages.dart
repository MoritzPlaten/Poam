import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Languages {
  German,
  English
}

String languagesAsString(BuildContext context, Languages languages) {
  String s = "";
  switch (languages) {
    case Languages.German:
      s = AppLocalizations.of(context)!.german;
      break;
    case Languages.English:
      s = AppLocalizations.of(context)!.english;
      break;
  }
  return s;
}

List<String> languagesAsListString(BuildContext context)  {
  List<String> languages = List.generate(Languages.values.length, (index) => "");

  for (int i = 0;i < languages.length;i++) {
    languages[i] = languagesAsString(context, Languages.values.elementAt(i));
  }

  return languages;
}