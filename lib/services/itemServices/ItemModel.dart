import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:hive/hive.dart';

import '../dateServices/Objects/Frequency.dart';
import 'Objects/Database.dart';

part 'ItemModel.g.dart';

///TODO: Add Color for the PoamItem, for the decoration. the user can choose a color
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
  DateTime time;
  @HiveField(7)
  DateTime date;
  @HiveField(8)
  Frequency frequency;

  ItemModel (this.title, this.count, this.isChecked, this.person, this.categories, this.hex, this.time, this.date, this.frequency);

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

}