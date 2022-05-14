import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../itemServices/Objects/Database.dart';
import '../keyServices/KeyService.dart';

part 'Settings.g.dart';

@HiveType(typeId: 6)
class Settings extends ChangeNotifier {

  @HiveField(0)
  int ColorHex;

  Settings(this.ColorHex);

  List<Settings> _settings = <Settings>[];
  List<Settings> get settings => _settings;

  Future<List<int>> getSettingsKey() async {

    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.SettingsKey);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: KeyService.SettingsKey, value: base64UrlEncode(key));
    }

    String? read = await secureStorage.read(key: KeyService.SettingsKey);

    var encryptionKey = base64Url.decode(read!);
    return encryptionKey;
  }

  void getSettings() async {
    var settingsKey = await getSettingsKey();
    final box = await Hive.openBox<Settings>(Database.SettingsName, encryptionCipher: HiveAesCipher(settingsKey));

    _settings = box.values.toList();
    notifyListeners();
  }

  void initializeSettings(Settings settings) async {
    var settingsKey = await getSettingsKey();
    final box = await Hive.openBox<Settings>(Database.SettingsName, encryptionCipher: HiveAesCipher(settingsKey));

    if (box.values.length == 0) {

      box.add(settings);
      notifyListeners();
    }
  }

  ///Set the Settings to our db
  void setSettings(Settings settings) async {
    var settingsKey = await getSettingsKey();
    final box = await Hive.openBox<Settings>(Database.SettingsName, encryptionCipher: HiveAesCipher(settingsKey));

    if (box.values.length != 0) {
      box.putAt(0, settings);
    }

    notifyListeners();
  }

}