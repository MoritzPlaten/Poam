import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'QuantityType.dart';

part 'Amounts.g.dart';

@HiveType(typeId: 8)
class Amounts {

  @HiveField(0)
  int? Number;
  @HiveField(1)
  QuantityType? quantityType;

  @HiveField(1)
  Amounts(this.Number, this.quantityType);
}

///Display the Category as String
String displayTextQuantityType(BuildContext context, QuantityType quantityType) {

  String displayTest = "";
  switch(quantityType) {
    case QuantityType.Pieces:

      displayTest = AppLocalizations.of(context)!.pieces;
      break;
    case QuantityType.Liter:

      displayTest = "Liter";
      break;
  }
  return displayTest;
}

QuantityType stringToQuantityType(BuildContext context, String value) {

  QuantityType quantityType = QuantityType.values.last;

  if (value == "Stücke" || value == "pieces" /*AppLocalizations.of(context)!.numberField*/) {
    quantityType = QuantityType.Pieces;
  }
  if (value == "Liter") {
    quantityType = QuantityType.Liter;
  }

  return quantityType;
}

///Display all Categories as List<String>
List<String> displayAllQuantityType(BuildContext context) {

  List<String> list = List.generate(QuantityType.values.length, (index) => "");

  for (int i = 0;i < list.length; i++) {
    list[i] = displayTextQuantityType(context, QuantityType.values.elementAt(i));
  }
  return list;
}