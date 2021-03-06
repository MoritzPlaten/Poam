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
  ChartService? selectedChart;

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
                      create: (_) => ItemModel("", Amounts(0, QuantityType.Pieces), false, Person(""), Categories.tasks, "#FFFFFF", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", Alarms([]), false, false),
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
                  style: TextStyle(
                      fontFamily: "Mona",
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

            ///PoamChart
            if (widget.categories! == Categories.tasks)
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

                    ///PoamChart
                    PoamChart(
                      updateSelectedChart: (val) => selectedChart = val,
                    ),

                    ///if a Bar in the BarChart is selected then this will pop up
                    selectedChart != null ?
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.035, right: size.width * 0.04),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            AppLocalizations.of(context)!.date + ": " + DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedChart!.dateTime) +
                                "\n" +AppLocalizations.of(context)!.notChecked + ": " + selectedChart!.isNotChecked.toString() +
                                "\n" + AppLocalizations.of(context)!.checked + ": " + selectedChart!.isChecked.toString(),
                            style: TextStyle(fontFamily: "Mona", fontSize: 13)
                          ),
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
            if (widget.allItems!.isEmpty != true)
              ListView.builder(
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.categories != Categories.shopping ? dateService.getListOfAllDates(widget.allItems!.where((element) => element.categories == widget.categories!).take(numberOfItemsOnStartScreen)).length : 1,
              itemBuilder: (BuildContext context, int index) {

                ///All Items will packed in a PoamDateItem, which display the Date
                return PoamDateItem(
                  allItems: dateService.sortItemsByDate(widget.allItems!.where((element) => element.categories == widget.categories).toList()).take(numberOfItemsOnStartScreen),
                  categories: widget.categories,
                  dateIndex: index,
                );
              },
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
                  style: TextStyle(
                      fontFamily: "Mona",
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
                style: TextStyle(fontFamily: "Mona", fontSize: 12.5)
              ),
            ),

          ],
        ),

      ),
    );
  }
}