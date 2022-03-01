import 'package:hive/hive.dart';

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
String displayFrequency(Frequency frequency) {
  String value;
  switch(frequency) {
    case Frequency.single:
      value = "Einmalig";
      break;
    case Frequency.daily:
      value = "Täglich";
      break;
    case Frequency.weekly:
      value = "Wöchentlich";
      break;
    case Frequency.monthly:
      value = "Monatlich";
      break;
    case Frequency.yearly:
      value = "Jährlich";
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
List<String> displayAllFrequency() {
  List<String> list = List.generate(Frequency.values.length, (index) => "");

  for (int i = 0;i < list.length; i++) {
    list[i] = displayFrequency(Frequency.values.elementAt(i));
  }
  return list;
}