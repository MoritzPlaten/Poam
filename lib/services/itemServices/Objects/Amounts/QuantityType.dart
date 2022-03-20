import 'package:hive/hive.dart';

part 'QuantityType.g.dart';

@HiveType(typeId: 7)
enum QuantityType {
  @HiveField(0)
  Pieces,
  @HiveField(1)
  Liter
}