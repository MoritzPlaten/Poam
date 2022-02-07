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

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    //Item Lists
    List<dynamic> items = Provider.of<MenuService>(context).items;

    return SizedBox(

      width: size.width,

      child: ListView(

        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [

          PoamMenu(
            title: displayTextCategory(Categories.tasks),
            iconData: displayIconCategory(Categories.tasks),
            items: items.where((element) => element.categories == Categories.tasks),
          ),

          PoamMenu(
            title: displayTextCategory(Categories.shopping),
            iconData: displayIconCategory(Categories.shopping),
            items: items.where((element) => element.categories == Categories.shopping),
          ),

        ],
      ),
    );
  }
}