import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Database.dart';
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

  late Size size;
  late DateService dateService;

  @override
  Widget build(BuildContext context) {

    ///Refresh Items
    context.watch<ItemModel>().getItems();

    ///Initialize
    size = MediaQuery.of(context).size;
    dateService = DateService();

    return Scaffold(

      appBar: AppBar(
        title: Text(
          ///Display the Category
          displayTextCategory(context, widget.categories!),
          style: GoogleFonts.novaMono(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
      ),

      body: ValueListenableBuilder(
          valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
          builder: (context, Box<ItemModel> box, _) {
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [

                ///All Items will packed in a PoamDateItem, which display the Date
                PoamDateItem(
                  allItems: dateService.sortItemsByDate(box.values.where((element) => element.categories == widget.categories).toList()),
                  categories: widget.categories,
                ),

                ///When no items are there
                if (box.values.where((element) => element.categories == widget.categories).isEmpty == true)
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      "Die " + displayTextCategory(context, widget.categories!) + " ist leer!",
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