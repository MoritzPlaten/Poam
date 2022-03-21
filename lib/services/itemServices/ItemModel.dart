import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../dateServices/Objects/Frequency.dart';
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
  bool expanded;

  ItemModel (this.title, this.amounts, this.isChecked, this.person, this.categories, this.hex, this.fromTime, this.fromDate, this.toTime, this.toDate,this.frequency, this.description, this.expanded);

  List<ItemModel> _itemModelList = <ItemModel>[];
  List<ItemModel> get itemModelList => _itemModelList;

  void getItems() async {
    final box = await Hive.openBox<ItemModel>(Database.Name);

    _itemModelList = box.values.toList();
    notifyListeners();
  }

  ///Remove the ItemModel from our db
  void removeItem(ItemModel item) async {
    var box = await Hive.openBox<ItemModel>(Database.Name);
    box.deleteAt(itemModelList.indexOf(item));
    notifyListeners();
  }

  ///Add the ItemModel to our db
  void addItem(ItemModel item) async {
    var box = await Hive.openBox<ItemModel>(Database.Name);

    box.add(item);
    notifyListeners();
  }

  ///Change the ItemModel to our db
  void putItem(int index, ItemModel item) async {
    var box = await Hive.openBox<ItemModel>(Database.Name);

    box.putAt(index, item);
    notifyListeners();
  }

  void changeItems(BuildContext context) async {

    var box = await Hive.openBox<ItemModel>(Database.Name);
    var chartBox = await Hive.openBox<ChartService>(Database.ChartName);
    DateTime now = DateTime.now();

    _itemModelList.where((element) => element.fromDate.compareTo(DateTime(now.year, now.month, now.day)) < 0).forEach((element) {
      ItemModel model = element;

      ///ChartModel
      ChartService chartService = ChartService(0, 0, DateTime(0));
      List<ChartService> chartList = chartBox.values.toList();

      if (model.fromDate.compareTo(DateTime(now.year, now.month, now.day)) != 0 && model.categories == Categories.tasks) {

        DateTime _now = DateTime(now.year, now.month, now.day);
        int numberOfFromDate = chartBox.values.where((element) => element.dateTime.compareTo(model.fromDate) == 0).last.isNotChecked;
        int numberOfToday = chartBox.values.where((element) => element.dateTime.compareTo(_now) == 0).last.isNotChecked;

        Provider.of<ChartService>(context, listen: false).putNotChecked(_now, numberOfToday + numberOfFromDate);
        Provider.of<ChartService>(context, listen: false).putNotChecked(model.fromDate, numberOfFromDate < 0 ? numberOfFromDate - 1 : 0);
      }

      model.fromDate = DateTime(now.year, now.month, now.day);
      box.putAt(_itemModelList.indexOf(element), model);
    });

  }
}