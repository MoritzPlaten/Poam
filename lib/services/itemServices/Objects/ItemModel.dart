import 'package:flutter/cupertino.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';

class ItemModel {

  String? title;
  int? count;
  bool? isChecked;
  Person? person;
  Categories? categories;
  String? date;

  ItemModel setItemModel (String title, int count, bool isChecked, Person person, Categories categories, String date) {
    ItemModel itemModel = ItemModel();
    itemModel.title = title;
    itemModel.count = count;
    itemModel.isChecked = isChecked;
    itemModel.person = person;
    itemModel.categories = categories;
    itemModel.date = date;
    return itemModel;
  }

}