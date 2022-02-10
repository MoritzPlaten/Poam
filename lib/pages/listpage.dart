import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamDateItem/PoamDateItem.dart';
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

    Color primaryColor = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;

    List<dynamic> items = Provider.of<MenuService>(context).getItems;
    Iterable categoryItems = items.where((element) => element.categories == widget.category!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayTextCategory(widget.category!),
          style: GoogleFonts.novaMono(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          ///TODO: Items are not the Same with the items from the start screen => because of the db
          /*for (int i = 0; i < categoryItems.length;i++) PoamItem(
            itemIndex: i,
            itemModel: categoryItems.elementAt(i),
          ), */

          PoamDateItem(
            allItems: categoryItems,
            category: widget.category,
          ),

          if (categoryItems.isEmpty == true) Container(
            width: size.width,
            alignment: Alignment.center,
            height: 50,
            child: Text(
              "Die " + displayTextCategory(widget.category!) + " ist leer!",
              style: const TextStyle(
                fontSize: 16
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: const PoamFloatingButton(),
    );
  }
}