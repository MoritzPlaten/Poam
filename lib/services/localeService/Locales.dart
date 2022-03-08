import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../itemServices/Objects/Database.dart';

part 'Locales.g.dart';

@HiveType(typeId: 4)
class Locales extends ChangeNotifier {

  @HiveField(0)
  String locale;

  Locales(this.locale);

  List<Locales> _locales = <Locales>[];
  List<Locales> get locales => _locales;

  void getLocale() async {
    final box = await Hive.openBox<Locales>(Database.LocaleName);

    _locales = box.values.toList();
    notifyListeners();
  }

  void addLocale(Locales locales) async {
    var box = await Hive.openBox<Locales>(Database.LocaleName);

    if (box.values.length == 0) {

      box.add(locales);
      notifyListeners();
    }
  }

  ///Set the Locale to our db
  void setLocale(Locales locales) async {
    var box = await Hive.openBox<Locales>(Database.LocaleName);

    if (box.values.length != 0) {
      box.putAt(0, locales);
    }

    notifyListeners();
  }

}