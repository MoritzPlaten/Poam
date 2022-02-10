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
    ItemModel("Obst einkaufen", 2, false, Person(""), Categories.shopping, ""),
    ItemModel("Wäsche aufhängen", 0, false, Person("Moritz Platen"), Categories.tasks, "2021-12-12"),
    ItemModel("Kleider einkaufen", 1, false, Person(""), Categories.shopping, ""),
    ItemModel("Zimmer aufräumen", 0, false, Person("Vivien Konderla"), Categories.tasks, "2021-12-11"),
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

  List<String> getListOfAllDates(Iterable<dynamic> getItems) {
    List<String> dates = List.generate(getItems.length, (index) => "");
    for (int i = 0;i < dates.length; i++) {

      if (!dates.contains(getItems.elementAt(i).date)) {
        dates[i] = getItems.elementAt(i).date;
      }
    }
    for (int i = 0;i < getItems.length; i++) {
      dates.remove("");
    }

    dates.sort((a, b){ //sorting in ascending order
      return DateTime.parse(a).compareTo(DateTime.parse(b));
    });

    return dates;
  }
}