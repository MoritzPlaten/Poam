import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'Amounts.g.dart';

@HiveType(typeId: 7)
enum QuantityType {
  @HiveField(0)
  Number,
  @HiveField(1)
  Liter
}

@HiveType(typeId: 8)
class Amounts extends ChangeNotifier {

  @HiveField(0)
  int? Number;
  @HiveField(1)
  QuantityType? quantityType;

  @HiveField(1)
  Amounts(this.Number, this.quantityType);
}