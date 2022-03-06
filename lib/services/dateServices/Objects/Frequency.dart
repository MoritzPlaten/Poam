import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'Frequency.g.dart';

@HiveType(typeId: 3)
enum Frequency {

  @HiveField(0)
  single,
  @HiveField(1)
  daily,
  @HiveField(2)
  weekly,
  @HiveField(3)
  monthly,
  @HiveField(4)
  yearly
}

///Display the Frequency
String displayFrequency(BuildContext context, Frequency frequency) {
  String value;
  switch(frequency) {
    case Frequency.single:
      value = AppLocalizations.of(context)!.single;
      break;
    case Frequency.daily:
      value = AppLocalizations.of(context)!.daily;
      break;
    case Frequency.weekly:
      value = AppLocalizations.of(context)!.weekly;
      break;
    case Frequency.monthly:
      value = AppLocalizations.of(context)!.monthly;
      break;
    case Frequency.yearly:
      value = AppLocalizations.of(context)!.yearly;
      break;
  }
  return value;
}

///Get the Frequency object from text
Frequency getFrequency(String frequencyName) {
  Frequency value = Frequency.single;
  switch(frequencyName) {
    case "Einmalig":
      value = Frequency.single;
      break;
    case "Täglich":
      value = Frequency.daily;
      break;
    case "Wöchentlich":
      value = Frequency.weekly;
      break;
    case "Monatlich":
      value = Frequency.monthly;
      break;
    case "Jährlich":
      value = Frequency.yearly;
      break;
  }
  return value;
}

///Display all Frequency for DropDownValues or ...
List<String> displayAllFrequency(BuildContext context) {
  List<String> list = List.generate(Frequency.values.length, (index) => "");

  for (int i = 0;i < list.length; i++) {
    list[i] = displayFrequency(context, Frequency.values.elementAt(i));
  }
  return list;
}