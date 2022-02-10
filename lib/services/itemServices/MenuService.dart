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

  ///Remove the ItemModel from our db
  void removeItem(ItemModel item) {

    getItems.remove(item);
    notifyListeners();
  }

  ///Add the ItemModel from our db
  void addItem(ItemModel item) {

    getItems.add(item);
    notifyListeners();
  }

  ///Get the ItemModel by an index from the db
  ItemModel getItemByIndex(int index){
    return getItems.elementAt(index);
  }

  ///Get the ItemModel by an title from our db
  Iterable getItemByTitle(String title){
    return getItems.where((element) => element.title == title);
  }
}