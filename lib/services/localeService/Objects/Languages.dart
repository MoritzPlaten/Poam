import 'package:flutter/cupertino.dart';

enum Languages {
  German,
  English
}

String languagesAsString(BuildContext context, Languages languages) {
  String s = "";
  switch (languages) {
    case Languages.German:
      //s = AppLocalizations.of(context)!.german;
      s = "German";
      break;
    case Languages.English:
      //s = AppLocalizations.of(context)!.english;
      s = "English";
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

Locale languageToLocale(BuildContext context, String language) {

  String lang = "";

  if (language == "Deutsch" || language == "German") {
    lang = "de";
  } else if (language == "English" || language == "Englisch") {
    lang = "en";
  }

  return Locale(lang, "");
}