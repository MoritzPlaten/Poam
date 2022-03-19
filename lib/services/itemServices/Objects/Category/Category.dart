import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Category.g.dart';

@HiveType(typeId: 2)
enum Categories {
  @HiveField(0)
  tasks,
  @HiveField(1)
  shopping
}

///Display the Category as String
String displayTextCategory(BuildContext context, Categories categories) {
  String displayTest = "";
  switch(categories) {
    case Categories.shopping:

      displayTest = AppLocalizations.of(context)!.shoppingList;
      break;
    case Categories.tasks:
      displayTest = AppLocalizations.of(context)!.taskList;
      break;
  }
  return displayTest;
}

///Display all Categories as List<String>
List<String> displayAllCategories(BuildContext context) {
  List<String> list = List.generate(Categories.values.length, (index) => "");

  for (int i = 0;i < list.length; i++) {
    list[i] = displayTextCategory(context, Categories.values.elementAt(i));
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