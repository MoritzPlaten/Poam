import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';
import 'package:provider/src/provider.dart';

class PoamList extends StatefulWidget {
  const PoamList({ Key? key }) : super(key: key);

  @override
  _PoamListState createState() => _PoamListState();
}

class _PoamListState extends State<PoamList> {

  late List<dynamic> items;

  @override
  Widget build(BuildContext context) {

    ///initialize
    final size = MediaQuery.of(context).size;
    items = Provider.of<MenuService>(context).getItems;

    return SizedBox(

      width: size.width,

      child: ListView(

        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [

          PoamMenu(
            categories: Categories.tasks,
            ///the Items which will be display on start screen
            onlyFiveItems: items.where((element) => element.categories == Categories.tasks).take(5),
            isExistsMoreItems: items.where((element) => element.categories == Categories.tasks).length > 5 ? true : false,
            ///All items
            allItems: items.where((element) => element.categories == Categories.tasks).toList(),
            numberOfItems: items.where((element) => element.categories == Categories.tasks).length,
          ),

          PoamMenu(
            categories: Categories.shopping,
            ///the Items which will be display on start screen
            onlyFiveItems: items.where((element) => element.categories == Categories.shopping).take(5),
            isExistsMoreItems: items.where((element) => element.categories == Categories.shopping).length > 5 ? true : false,
            ///All items
            allItems: items.where((element) => element.categories == Categories.shopping).toList(),
            numberOfItems: items.where((element) => element.categories == Categories.shopping).length,
          ),

        ],
      ),
    );
  }
}