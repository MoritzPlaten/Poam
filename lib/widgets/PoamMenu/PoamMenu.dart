import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamChart/PoamChart.dart';
import 'package:poam/widgets/PoamDateItem/PoamDateItem.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:provider/provider.dart';
import '../../services/dateServices/DateService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoamMenu extends StatefulWidget {

  final List<ItemModel>? allItems;
  final Categories? categories;

  const PoamMenu({Key? key, this.allItems, this.categories }) : super(key: key);

  @override
  _PoamMenuState createState() => _PoamMenuState();
}

class _PoamMenuState extends State<PoamMenu> {

  late Size size;
  late Color primaryColor;
  late DateService dateService;
  late PoamSnackbar poamSnackbar;
  late int numberOfItemsOnStartScreen;

  @override
  Widget build(BuildContext context) {

    ///initialize
    dateService = DateService();
    poamSnackbar = PoamSnackbar();
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    numberOfItemsOnStartScreen = widget.categories == Categories.tasks ? 3 : 5;

    ///You can click on the PoamMenu, if it is empty it will show you a snack bar
    return GestureDetector(
      onTap: () => {

      ///It must exists Items
      if (widget.allItems!.isEmpty == false) {
          ///Navigate
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => ItemModel("", 0, false, Person(""), Categories.tasks, "#FFFFFF", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", false),
                    ),
                  ],
                  child: ListPage(
                    categories: widget.categories,
                  ),
                ),
            ),
          ),
        } else {

          ///The Snackbar
          poamSnackbar.showSnackBar(context, AppLocalizations.of(context)!.your + " " + displayTextCategory(context, widget.categories!) + " " + AppLocalizations.of(context)!.empty + "!", primaryColor),
        }

      },
      child: Container(

        width: size.width,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        margin: const EdgeInsets.only(top: 4, right: 2, left: 2, bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(

          children: [

            Row(
              children: [

                ///The title of the menu
                Text(
                  displayTextCategory(context, widget.categories!),
                  style: GoogleFonts.novaMono(
                      fontSize: 18
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ///The icon of the menu
                Icon(
                  displayIconCategory(widget.categories!),
                  size: 18,
                ),

              ],
            ),

            if (widget.categories! == Categories.tasks)
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => DateService(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => ChartService(),
                  ),
                ],
                child: const PoamChart(),
              ),

            const SizedBox(
              height: 10,
            ),

            ///All Items, which are sorted by date, will packed in a PoamDateItem, which display the Date
            PoamDateItem(
              allItems: dateService.sortItemsByDate(widget.allItems!.toList()).take(numberOfItemsOnStartScreen),
              categories: widget.categories!,
            ),

            ///When it exists more than the Items, than this will shows
            if ((widget.allItems!.length > numberOfItemsOnStartScreen) == true) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Flexible(
                  child: const Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),

                Text(
                  AppLocalizations.of(context)!.another + " " + (widget.allItems!.length - numberOfItemsOnStartScreen).toString() + " " + AppLocalizations.of(context)!.element,
                  style: GoogleFonts.novaMono(
                    fontSize: 12.5
                  ),
                ),

                const Flexible(
                  child: const Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),

              ],
            ),
            ///if no items are there, this will be display
            if (widget.allItems!.isEmpty == true) Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.your + " " + displayTextCategory(context, widget.categories!) + " " + AppLocalizations.of(context)!.empty + "!",
                style: GoogleFonts.novaMono(
                  fontSize: 12.5
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }
}
