import 'package:flutter/cupertino.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';

class MenuService extends ChangeNotifier {

  ///At the Moment the local db
  List<dynamic> items = [
    ItemModel().setItemModel("Obst einkaufen", 2, false, Person(), Categories.shopping, "07.02."),
    ItemModel().setItemModel("Wäsche aufhängen", 0, false, Person(), Categories.tasks, "07.02."),
    ItemModel().setItemModel("Kleider einkaufen", 1, false, Person(), Categories.shopping, "07.02."),
    ItemModel().setItemModel("Zimmer aufräumen", 0, false, Person(), Categories.tasks, "07.02."),
  ];

  void removeItem(ItemModel item) {

    items.remove(item);
    notifyListeners();
  }

  void addItem(ItemModel item) {

    items.add(item);
    notifyListeners();
  }

  ItemModel getItemByIndex(int index){
    return items.elementAt(index);
  }

  Iterable getItemByTitle(String title){
    return items.where((element) => element.title == title);
  }

}