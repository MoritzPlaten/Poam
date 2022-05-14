import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../dateServices/Objects/Frequency.dart';
import '../keyServices/KeyService.dart';
import 'Objects/Alarms/Alarms.dart';
import 'Objects/Amounts/Amounts.dart';
import 'Objects/Database.dart';

part 'ItemModel.g.dart';

@HiveType(typeId: 0)
class ItemModel extends ChangeNotifier {

  @HiveField(0)
  String title;
  @HiveField(1)
  Amounts amounts;
  @HiveField(2)
  bool isChecked;
  @HiveField(3)
  Person person;
  @HiveField(4)
  Categories categories;
  @HiveField(5)
  String hex;
  @HiveField(6)
  DateTime fromTime;
  @HiveField(7)
  DateTime fromDate;
  @HiveField(8)
  DateTime toTime;
  @HiveField(9)
  DateTime toDate;
  @HiveField(10)
  Frequency frequency;
  @HiveField(11)
  String description;
  @HiveField(12)
  Alarms alarms;
  @HiveField(13)
  bool AllowDate;
  @HiveField(14)
  bool expanded;

  ItemModel (this.title, this.amounts, this.isChecked, this.person, this.categories, this.hex, this.fromTime, this.fromDate, this.toTime, this.toDate,this.frequency, this.description, this.alarms, this.AllowDate, this.expanded);

  List<ItemModel> _itemModelList = <ItemModel>[];
  List<ItemModel> get itemModelList => _itemModelList;

  Future<List<int>> getKey() async {

    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.ItemModelKey);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: KeyService.ItemModelKey, value: base64UrlEncode(key));
    }

    String? read = await secureStorage.read(key: KeyService.ItemModelKey);

    var encryptionKey = base64Url.decode(read!);
    return encryptionKey;
  }

  void getItems() async {

    var s = await getKey();
    final box = await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(s));

    _itemModelList = box.values.toList();
    notifyListeners();
  }

  ///Remove the ItemModel from our db
  void removeItem(ItemModel item) async {

    var s = await getKey();
    final box = await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(s));
    box.deleteAt(itemModelList.indexOf(item));
    notifyListeners();
  }

  ///Add the ItemModel to our db
  void addItem(ItemModel item) async {

    var s = await getKey();
    final box = await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(s));

    box.add(item);
    notifyListeners();
  }

  ///Change the ItemModel to our db
  void putItem(int index, ItemModel item) async {

    var s = await getKey();
    final box = await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(s));

    box.putAt(index, item);
    notifyListeners();
  }

  void changeItems(BuildContext context, Future<Map<DateTime, int>> map) async {

    var s = await getKey();
    final box = await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(s));
    var chartBox = await Hive.openBox<ChartService>(Database.ChartName);
    var newMap = await map;
    DateTime now = DateTime.now();

    ///Gets all ItemModels which are passed
    _itemModelList.where((element) =>
    DateTime(element.fromDate.year, element.fromDate.month, element.fromDate.day, element.fromTime.hour, element.fromTime.minute)
        .compareTo(DateTime(now.year, now.month, now.day, now.hour, now.minute)) < 0 && (element.frequency == Frequency.single || element.frequency == Frequency.daily))
        .forEach((element) {

      ItemModel model = element;

      ///Date
      DateTime? _fromDate;
      DateTime? _toDate;
      if (model.fromDate.compareTo(DateTime(now.year, now.month, now.day)) !=
          0 && model.categories == Categories.tasks) {

        ///ItemModel
        Duration duration = model.fromDate.difference(model.toDate);

        _fromDate = DateTime(now.year, now.month, now.day);
        _toDate = DateTime(now.year, now.month, now.day).add(duration.abs());

        ///ChartModel
        int numberOfFromDate;

        ///Check the week is over, respectively if the map is current
        if (newMap.isNotEmpty && newMap.entries.last.key.isAfter(model.fromDate)) {

          ///Give the number of items last week which are unchecked
          numberOfFromDate = newMap.entries.firstWhere((e) => e.key.isAtSameMomentAs(model.fromDate)).value;
          print(numberOfFromDate);
        } else {

          ///Give the number of last day today which are unchecked
          numberOfFromDate = chartBox.values.where((e) => e.dateTime.isAtSameMomentAs(model.fromDate)).last.isNotChecked;
          print(numberOfFromDate);
        }

        Iterable<ChartService> listOfCharts = chartBox.values.where((element) => element.dateTime.compareTo(_fromDate!) == 0);

        ///Give the number of items today which are unchecked
        if (listOfCharts.isNotEmpty) {

          int numberOfToday = chartBox.values.where((element) => element.dateTime.compareTo(_fromDate!) == 0).last.isNotChecked;
          Provider.of<ChartService>(context, listen: false).putNotChecked(_fromDate, numberOfToday + numberOfFromDate);
        }
        Provider.of<ChartService>(context, listen: false).putNotChecked(model.fromDate, numberOfFromDate < 0 ? numberOfFromDate - 1 : 0);
      }

      ///Time
      DateTime? _fromTime;
      DateTime? _toTime;
      if (model.fromTime.compareTo(DateTime(0, 0, 0, now.hour, now.minute)) != 0 && model.frequency == Frequency.single && model.categories == Categories.tasks) {
        Duration duration = model.fromTime.difference(model.toTime);

        _fromTime = DateTime(0, 0, 0, now.hour, now.minute);
        _toTime = DateTime(0, 0, 0, now.hour, now.minute).add(duration.abs());
      }

      ///Put the Data in the Database
      if (model.categories == Categories.tasks &&
          (model.fromDate.compareTo(DateTime(now.year, now.month, now.day)) !=
              0 || model.fromTime.compareTo(
              DateTime(0, 0, 0, now.hour, now.minute)) != 0)) {
        if (_fromDate != null && _toDate != null) {
          model.fromDate = _fromDate;
          model.toDate = _toDate;
        }
        if (_fromTime != null && _toTime != null) {
          model.fromTime = _fromTime;
          model.toTime = _toTime;
        }
        box.putAt(_itemModelList.indexOf(element), model);
      }
    });

  }
}