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