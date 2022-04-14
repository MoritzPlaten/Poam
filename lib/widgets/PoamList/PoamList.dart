import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:poam/services/settingService/Settings.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/itemServices/Objects/Database.dart';
import '../../services/localeService/Locales.dart';

class PoamList extends StatelessWidget {
  const PoamList({Key? key}) : super(key: key);

  final List<Categories> categories = Categories.values;

  @override
  Widget build(BuildContext context) {

    ///initialize
    Size size = MediaQuery.of(context).size;

    ///Update Items
    context.watch<ItemModel>().getItems();
    context.watch<Locales>().getLocale();
    context.watch<Settings>().getSettings();
    context.watch<ChartService>().getCharts();

    ///Clear the Last Week
    Future<Map<DateTime, int>> map = Provider.of<ChartService>(context, listen: false).weekIsOver();

    ///Change ItemModels
    Provider.of<ItemModel>(context, listen: false).changeItems(context, map);

    ///initialize Classes
    Provider.of<Locales>(context, listen: false).initializeLocale(new Locales(languagesAsString(context, Languages.values.first)));
    Provider.of<Settings>(context, listen: false).initializeSettings(new Settings(ColorToHex(Colors.blueAccent).value));
    Provider.of<ChartService>(context, listen: false).initialize(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
      builder: (context, Box<ItemModel> box, widgets) {

        return SizedBox(

          width: size.width,
          child: ListView.builder(

            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {

              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => ChartService(0, 0, DateTime(0)),
                  ),
                ],
                child: PoamMenu(
                  categories: categories.elementAt(index),
                  ///All items
                  allItems: box.values.where((element) => element.categories == categories.elementAt(index)).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
