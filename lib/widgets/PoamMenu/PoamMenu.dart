import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:poam/widgets/PoamChart/PoamChart.dart';
import 'package:poam/widgets/PoamDateItem/PoamDateItem.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:provider/provider.dart';
import '../../services/dateServices/DateService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/itemServices/Objects/Alarms/Alarms.dart';
import '../../services/itemServices/Objects/Amounts/Amounts.dart';
import '../../services/itemServices/Objects/Amounts/QuantityType.dart';

class PoamMenu extends StatelessWidget {

  final List<ItemModel>? allItems;
  final Categories? categories;

  PoamMenu({ Key? key, this.allItems, this.categories }) : super(key: key);

  ChartService? selectedChart;

  @override
  Widget build(BuildContext context) {

    ///initialize
    DateService dateService = DateService();
    PoamSnackbar poamSnackbar = PoamSnackbar();
    Size size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    int numberOfItemsOnStartScreen = this.categories == Categories.tasks ? 3 : 5;

    ///You can click on the PoamMenu, if it is empty it will show you a snack bar
    return GestureDetector(
      onTap: () => {

        ///It must exists Items
        if (this.allItems!.isEmpty == false) {
          ///Navigate
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => ItemModel("", Amounts(0, QuantityType.Pieces), false, Person(""), Categories.tasks, "#FFFFFF", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", Alarms([]), false),
                    ),
                  ],
                  child: ListPage(
                    categories: this.categories,
                  ),
                ),
            ),
          ),
        } else {

          ///The Snackbar
          poamSnackbar.showSnackBar(context, AppLocalizations.of(context)!.your + " " + displayTextCategory(context, this.categories!) + " " + AppLocalizations.of(context)!.empty + "!", primaryColor),
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
                  displayTextCategory(context, this.categories!),
                  style: GoogleFonts.novaMono(
                      fontSize: 18
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ///The icon of the menu
                Icon(
                  displayIconCategory(this.categories!),
                  size: 18,
                ),

              ],
            ),

            ///PoamChart
            if (this.categories! == Categories.tasks)
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => DateService(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => ChartService(0, 0, DateTime(0)),
                  ),
                ],
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [

                    PoamChart(
                      updateSelectedChart: (val) => selectedChart = val,
                    ),

                    selectedChart != null ?
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.05, right: size.width * 0.04),
                      child: Text(
                        AppLocalizations.of(context)!.date + ": " + DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedChart!.dateTime) +
                            "\n" +AppLocalizations.of(context)!.notChecked + ": " + selectedChart!.isNotChecked.toString() +
                            "\n" + AppLocalizations.of(context)!.checked + ": " + selectedChart!.isChecked.toString(),
                        style: GoogleFonts.novaMono(
                            fontSize: 13
                        ),
                      ),
                    ) : Container(),

                  ],
                ),
              ),

            const SizedBox(
              height: 10,
            ),

            ///All Items, which are sorted by date, will packed in a PoamDateItem, which display the Date
            if (this.allItems!.isEmpty != true)
              ListView.builder(
                padding: const EdgeInsets.all(10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.categories != Categories.shopping ? dateService.getListOfAllDates(this.allItems!.where((element) => element.categories == this.categories!).take(numberOfItemsOnStartScreen)).length : 1,
                itemBuilder: (BuildContext context, int index) {

                  ///All Items will packed in a PoamDateItem, which display the Date
                  return PoamDateItem(
                    allItems: dateService.sortItemsByDate(this.allItems!.where((element) => element.categories == this.categories).toList()).take(numberOfItemsOnStartScreen),
                    categories: this.categories,
                    dateIndex: index,
                  );
                },
              ),

            ///When it exists more than the Items, than this will shows
            if ((this.allItems!.length > numberOfItemsOnStartScreen) == true) Row(
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
                  AppLocalizations.of(context)!.another + " " + (this.allItems!.length - numberOfItemsOnStartScreen).toString() + " " + AppLocalizations.of(context)!.element,
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
            if (this.allItems!.isEmpty == true) Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.your + " " + displayTextCategory(context, this.categories!) + " " + AppLocalizations.of(context)!.empty + "!",
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
