import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../itemServices/Objects/Database.dart';

part 'Settings.g.dart';

@HiveType(typeId: 6)
class Settings extends ChangeNotifier {

  @HiveField(0)
  int ColorHex;

  Settings(this.ColorHex);

  List<Settings> _settings = <Settings>[];
  List<Settings> get settings => _settings;

  void getSettings() async {
    final box = await Hive.openBox<Settings>(Database.SettingsName);

    _settings = box.values.toList();
    notifyListeners();
  }

  void initializeSettings(Settings settings) async {
    var box = await Hive.openBox<Settings>(Database.SettingsName);

    if (box.values.length == 0) {

      box.add(settings);
      notifyListeners();
    }
  }

  ///Set the Settings to our db
  void setSettings(Settings settings) async {
    var box = await Hive.openBox<Settings>(Database.SettingsName);

    if (box.values.length != 0) {
      box.putAt(0, settings);
    }

    notifyListeners();
  }

}