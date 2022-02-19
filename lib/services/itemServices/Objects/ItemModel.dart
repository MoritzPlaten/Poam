import 'package:flutter/cupertino.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:hive/hive.dart';

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
  DateTime date;

  ItemModel (this.title, this.count, this.isChecked, this.person, this.categories, this.date);

  List _itemModelList = <ItemModel>[];
  List get itemModelList => _itemModelList;

  void getItems() async {
    final box = await Hive.openBox<ItemModel>('items_db');

    _itemModelList = box.values.toList();
    notifyListeners();
  }

  ///Remove the ItemModel from our db
  void removeItem(ItemModel item) async {
    var box = await Hive.openBox<ItemModel>('items_db');
    box.deleteAt(_itemModelList.indexOf(item));
    notifyListeners();
  }

  ///Add the ItemModel from our db
  void addItem(ItemModel item) async {
    var box = await Hive.openBox<ItemModel>('items_db');

    box.add(item);
    notifyListeners();
  }

}