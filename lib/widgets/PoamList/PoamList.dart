import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';
import 'package:provider/src/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PoamList extends StatefulWidget {
  const PoamList({ Key? key }) : super(key: key);

  @override
  _PoamListState createState() => _PoamListState();
}

class _PoamListState extends State<PoamList> {

  @override
  Widget build(BuildContext context) {

    ///initialize
    final size = MediaQuery.of(context).size;

    ///Update Items
    context.watch<ItemModel>().getItems();

    return ValueListenableBuilder(
      valueListenable: Hive.box<ItemModel>("items_database").listenable(),
      builder: (context, Box box, widget) {
        return SizedBox(

          width: size.width,
          child: ListView(

            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [

              PoamMenu(
                categories: Categories.tasks,
                ///All items
                allItems: box.values.where((element) => element.categories == Categories.tasks).toList() as List<ItemModel>,
              ),

              PoamMenu(
                categories: Categories.shopping,
                ///All items
                allItems: box.values.where((element) => element.categories == Categories.shopping).toList() as List<ItemModel>,
              ),

            ],
          ),
        );
      },
    );
  }
}