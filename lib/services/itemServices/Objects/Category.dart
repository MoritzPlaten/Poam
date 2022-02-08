import 'package:flutter/material.dart';

enum Categories {
  shopping,
  tasks
}

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