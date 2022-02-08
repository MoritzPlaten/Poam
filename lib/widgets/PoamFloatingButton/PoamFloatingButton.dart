import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:provider/provider.dart';

class PoamFloatingButton extends StatefulWidget {
  const PoamFloatingButton({Key? key}) : super(key: key);

  @override
  _PoamFloatingButtonState createState() => _PoamFloatingButtonState();
}

class _PoamFloatingButtonState extends State<PoamFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        setState(() {
          //Add Items to the List
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Zimmer aufräumen", 1, false, Categories.tasks, "07/02/2022"));
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Gurken holen", 1, false, Categories.shopping, "07/02/2022"));
        })
      },
      child: const Icon(Icons.add),
    );
  }
}
