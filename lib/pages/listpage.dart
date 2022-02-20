import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/widgets/PoamDateItem/PoamDateItem.dart';
import 'package:poam/widgets/PoamFloatingButton/PoamFloatingButton.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {

  final Categories? categories;

  const ListPage({Key? key, this.categories }) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  @override
  Widget build(BuildContext context) {

    context.watch<ItemModel>().getItems();
    final size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          ///Display the Category
          displayTextCategory(widget.categories!),
          style: GoogleFonts.novaMono(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
      ),

      body: ValueListenableBuilder(
          valueListenable: Hive.box<ItemModel>("items_database").listenable(),
          builder: (context, Box box, _) {
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [

                ///All Items will packed in a PoamDateItem, which display the Date
                PoamDateItem(
                  allItems: box.values.where((element) => element.categories == widget.categories).toList() as List<ItemModel>,
                  categories: widget.categories,
                ),

                ///When no items are there
                if (box.values.where((element) => element.categories == widget.categories).isEmpty == true) Container(
                  width: size.width,
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    "Die " + displayTextCategory(widget.categories!) + " ist leer!",
                    style: GoogleFonts.novaMono(),
                  ),
                ),

              ],
            );
          }
      ),
      floatingActionButton: const PoamFloatingButton(),
    );
  }
}