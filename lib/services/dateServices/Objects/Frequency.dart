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
Frequency getFrequency(context, String frequencyName) {
  Frequency value = Frequency.single;

  if (frequencyName == AppLocalizations.of(context)!.single) {
    value = Frequency.single;
  } else if (frequencyName == AppLocalizations.of(context)!.daily) {
    value = Frequency.daily;
  } else if (frequencyName == AppLocalizations.of(context)!.weekly) {
    value = Frequency.weekly;
  } else if (frequencyName == AppLocalizations.of(context)!.monthly) {
    value = Frequency.monthly;
  } else if (frequencyName == AppLocalizations.of(context)!.yearly) {
    value = Frequency.yearly;
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