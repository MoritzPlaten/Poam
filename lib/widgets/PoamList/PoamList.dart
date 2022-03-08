import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';
import 'package:provider/src/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/itemServices/Objects/Database.dart';

class PoamList extends StatefulWidget {
  const PoamList({ Key? key }) : super(key: key);

  @override
  _PoamListState createState() => _PoamListState();
}

class _PoamListState extends State<PoamList> {

  late Size size;
  late List<Categories> categories = Categories.values;

  @override
  Widget build(BuildContext context) {

    ///initialize
    size = MediaQuery.of(context).size;

    ///Update Items
    context.watch<ItemModel>().getItems();

    return ValueListenableBuilder(
      valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
      builder: (context, Box box, widget) {
        return SizedBox(

          width: size.width,
          child: ListView.builder(

            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {

              return PoamMenu(
                categories: categories.elementAt(index),
                ///All items
                allItems: box.values.where((element) => element.categories == categories.elementAt(index)).toList() as List<ItemModel>,
              );
            },
          ),
        );
      },
    );
  }
}