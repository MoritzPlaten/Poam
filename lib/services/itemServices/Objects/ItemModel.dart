import 'package:flutter/cupertino.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';

class ItemModel {

  String title;
  int count;
  bool isChecked;
  Person person;
  Categories categories;
  String date;

  ItemModel (this.title, this.count, this.isChecked, this.person, this.categories, this.date);

}