import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';

class MenuService extends ChangeNotifier {

  ///At the Moment the local db
  List<dynamic> getItems = [
    ItemModel().setItemModel("Obst einkaufen", 2, false, Person(), Categories.shopping, "07.02."),
    ItemModel().setItemModel("Wäsche aufhängen", 0, false, Person(), Categories.tasks, "07.02."),
    ItemModel().setItemModel("Kleider einkaufen", 1, false, Person(), Categories.shopping, "07.02."),
    ItemModel().setItemModel("Zimmer aufräumen", 0, false, Person(), Categories.tasks, "07.02."),
  ];

  void removeItem(ItemModel item) {

    getItems.remove(item);
    notifyListeners();
  }

  void addItem(ItemModel item) {

    getItems.add(item);
    notifyListeners();
  }

  ItemModel getItemByIndex(int index){
    return getItems.elementAt(index);
  }

  Iterable getItemByTitle(String title){
    return getItems.where((element) => element.title == title);
  }
}