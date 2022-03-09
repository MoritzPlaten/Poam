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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

            return SizedBox(
              height: size.height,

              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                ///counts the ItemModels
                ///TODO: Hier gabs Probleme
                itemCount: /*box.values.where((element) => element.categories == widget.categories).isEmpty == true ?
                1 : dateService.getListOfAllDates(box.values.where((element) => element.categories == widget.categories)).length*/ 1,
                itemBuilder: (BuildContext context, int index) {

                  ///if the list is empty display text
                  if (box.values.where((element) => element.categories == widget.categories).isEmpty == true)
                    return Container(
                      width: size.width,
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        AppLocalizations.of(context)!.your + " " + displayTextCategory(context, widget.categories!) + " " + AppLocalizations.of(context)!.empty,
                        style: GoogleFonts.novaMono(),
                      ),
                    );

                  ///All Items will packed in a PoamDateItem, which display the Date
                  return PoamDateItem(
                    allItems: dateService.sortItemsByDate(box.values.where((element) => element.categories == widget.categories).toList()),
                    categories: widget.categories,
                  );

                },
              ),
            );
          }
      ),
      floatingActionButton: const PoamFloatingButton(),
    );
  }
}