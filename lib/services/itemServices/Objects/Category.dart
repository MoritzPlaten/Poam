import 'package:flutter/material.dart';

enum Categories {
  shopping,
  tasks
}

///Display the Category as String
String displayTextCategory(Categories categories) {
  String displayTest = "";
  switch(categories) {
    case Categories.shopping:
      displayTest = "Einkaufsliste";
      break;
    case Categories.tasks:
      displayTest = "Aufgabenliste";
      break;
  }
  return displayTest;
}

///Display all Categories as List<String>
List<String> displayAllCategories() {
  List<String> list = List.generate(Categories.values.length, (index) => "");

  for (int i = 0;i < list.length; i++) {
    list[i] = displayTextCategory(Categories.values.elementAt(i));
  }
  return list;
}

///Display the Icon of every Category
IconData displayIconCategory(Categories categories) {
  IconData iconData;
  switch(categories) {
    case Categories.shopping:
      iconData = Icons.shopping_bag_outlined;
      break;
    case Categories.tasks:
      iconData = Icons.task_alt_outlined;
      break;
  }
  return iconData;
}

int numberOfCategories() {
  return Categories.values.length;
}