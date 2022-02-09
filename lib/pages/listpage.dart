import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamFloatingButton/PoamFloatingButton.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {

  final Categories? category;

  const ListPage({Key? key, this.category }) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  @override
  Widget build(BuildContext context) {

    List<dynamic> items = Provider.of<MenuService>(context).getItems;
    Iterable categoryItems = items.where((element) => element.categories == widget.category!);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          ///TODO: Items are not the Same with the items from the start screen => because of the db
          for (int i = 0; i < categoryItems.length;i++) PoamItem(
            itemIndex: i,
            itemModel: categoryItems.elementAt(i),
          ),

        ],
      ),
      floatingActionButton: const PoamFloatingButton(),
    );
  }
}