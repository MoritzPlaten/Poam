import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamFloatingButton/PoamFloatingButton.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {

  final List<dynamic>? itemsModel;
  final Categories? category;

  const ListPage({Key? key, this.itemsModel, this.category }) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          ///TODO: Items remove and add (At the moment there are problems)
          for (int i = 0; i < widget.itemsModel!.length;i++) PoamItem(
            itemIndex: i,
            itemModel: widget.itemsModel![i],
          ),

        ],
      ),
      floatingActionButton: const PoamFloatingButton(),
    );
  }
}