import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:hive/hive.dart';

import '../dateServices/Objects/Frequency.dart';
import 'Objects/Database.dart';

part 'ItemModel.g.dart';

@HiveType(typeId: 0)
class ItemModel extends ChangeNotifier {

  @HiveField(0)
  String title;
  @HiveField(1)
  int count;
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

  ItemModel (this.title, this.count, this.isChecked, this.person, this.categories, this.hex, this.fromTime, this.fromDate, this.toTime, this.toDate,this.frequency, this.description, this.expanded);

  List _itemModelList = <ItemModel>[];
  List get itemModelList => _itemModelList;

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

  ///Add the ItemModel from our db
  void addItem(ItemModel item) async {
    var box = await Hive.openBox<ItemModel>(Database.Name);

    box.add(item);
    notifyListeners();
  }

  ///TODO: If an item has expired, then it should be put it for today

}