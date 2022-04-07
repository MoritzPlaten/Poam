import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/chartServices/ChartService.dart';
import '../../services/itemServices/Objects/Database.dart';

class PoamDateItem extends StatelessWidget {

  final Iterable<ItemModel>? allItems;
  final Categories? categories;
  final int? dateIndex;

  const PoamDateItem({ Key? key, this.allItems, this.categories, this.dateIndex }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    DateService dateService = DateService();
    List<DateTime> dates = dateService.getListOfAllDates(this.allItems!
        .where((element) => element.categories == Categories.tasks));
    Color primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        ///Display a Column, when the Category shopping is
        (this.categories! == Categories.shopping)
            ? ExpansionPanelList(
          elevation: 0,
          children: [
            for (int i = 0; i < this.allItems!.length; i++)
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return PoamItem(
                    itemIndex: i,
                    itemModel: this.allItems!.elementAt(i),
                  );
                },
                body: Column(
                  children: [
                    ///Displays Description of Shopping elements
                    if (this.allItems!
                        .elementAt(this.dateIndex!)
                        .description !=
                        "")
                      CostumListTile(
                        color: primaryColor,
                        size: size,
                        dates: dates,
                        Index: i,
                        title: AppLocalizations.of(context)!
                            .descriptionField,
                        body: this.allItems!.elementAt(i).description,
                      ),
                  ],
                ),
                isExpanded: this.allItems!.elementAt(i).expanded,
              ),
          ],
          expansionCallback: (int item, bool status) {
            if (!this.allItems!.elementAt(item).description.isEmpty) {
              this.allItems!.elementAt(item).expanded = !status;
            }
          },
        )
            :

        ///Display the Items with the Date

        ValueListenableBuilder(
            valueListenable:
            Hive.box<ChartService>(Database.ChartName).listenable(),
            builder:
                (BuildContext context, Box<ChartService> box, widgets) {
              return Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                          DateFormat.EEEE(Localizations.localeOf(context)
                              .languageCode)
                              .format(dates[this.dateIndex!]) +
                              " - " +
                              DateFormat.yMd(Localizations.localeOf(context)
                                  .languageCode)
                                  .format(dates[this.dateIndex!]),
                          style: GoogleFonts.novaMono(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                      const Flexible(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ),
                    ],
                  ),

                  ///Adds all Items with the correct date to the element
                  ExpansionPanelList(
                    elevation: 0,
                    children: [
                      for (int i = 0;
                      i <
                          this.allItems!
                              .where((element) =>
                          element.fromDate ==
                              dates[this.dateIndex!])
                              .length;
                      i++)
                        if (DateTime(
                            this.allItems!
                                .where((element) =>
                            element.fromDate ==
                                dates[this.dateIndex!])
                                .elementAt(i)
                                .fromDate
                                .year,
                            this.allItems!
                                .where((element) =>
                            element.fromDate ==
                                dates[this.dateIndex!])
                                .elementAt(i)
                                .fromDate
                                .month,
                            this.allItems!
                                .where((element) =>
                            element.fromDate ==
                                dates[this.dateIndex!])
                                .elementAt(i)
                                .fromDate
                                .day) ==
                            dates[this.dateIndex!])
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              ///Displays the PoamItem
                              return PoamItem(
                                itemIndex: i,
                                itemModel: this.allItems!
                                    .where((element) =>
                                element.fromDate ==
                                    dates[this.dateIndex!])
                                    .elementAt(i),
                              );
                            },
                            body: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 2, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        ///Displays the frequency
                                        if (this.allItems!
                                            .where((element) =>
                                        element.fromDate ==
                                            dates[
                                            this.dateIndex!])
                                            .elementAt(i)
                                            .frequency !=
                                            "")
                                          CostumListTile(
                                            color: primaryColor,
                                            size: size,
                                            dates: dates,
                                            Index: i,
                                            title: AppLocalizations.of(
                                                context)!
                                                .frequency,
                                            body: displayFrequency(
                                                context,
                                                this.allItems!
                                                    .where((element) =>
                                                element.fromDate ==
                                                    dates[this
                                                        .dateIndex!])
                                                    .elementAt(i)
                                                    .frequency),
                                          ),

                                        const SizedBox(
                                          height: 6,
                                        ),

                                        ///Displays the Description
                                        if (this.allItems!
                                            .where((element) =>
                                        element.fromDate ==
                                            dates[
                                            this.dateIndex!])
                                            .elementAt(i)
                                            .description !=
                                            "")
                                          CostumListTile(
                                            color: primaryColor,
                                            size: size,
                                            dates: dates,
                                            Index: i,
                                            title: AppLocalizations.of(
                                                context)!
                                                .descriptionField,
                                            body: this.allItems!
                                                .where((element) =>
                                            element.fromDate ==
                                                dates[
                                                this.dateIndex!])
                                                .elementAt(i)
                                                .description
                                                .trim(),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (this.allItems!
                                      .where((element) =>
                                  element.fromDate ==
                                      dates[this.dateIndex!])
                                      .elementAt(i)
                                      .frequency !=
                                      Frequency.single)

                                  ///Delete Button: displays if the frequency != single
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: () {

                                          ///ItemModel
                                          this.allItems!
                                              .where(
                                                  (element) =>
                                              element
                                                  .fromDate ==
                                                  dates[this
                                                      .dateIndex!])
                                              .elementAt(i)
                                              .isChecked =
                                          !this.allItems!
                                              .where((element) =>
                                          element.fromDate ==
                                              dates[this
                                                  .dateIndex!])
                                              .elementAt(i)
                                              .isChecked;
                                          Provider.of<ItemModel>(context,
                                              listen: false)
                                              .removeItem(this.allItems!
                                              .where((element) =>
                                          element.fromDate ==
                                              dates[this
                                                  .dateIndex!])
                                              .elementAt(i));

                                          ///ChartModel
                                          if (this.allItems!
                                              .where((element) =>
                                          element.fromDate ==
                                              dates[this
                                                  .dateIndex!])
                                              .elementAt(i)
                                              .categories ==
                                              Categories.tasks) {
                                            ChartService chartService =
                                            ChartService(
                                                0, 0, DateTime(0));

                                            Provider.of<ChartService>(context, listen: false).putNotChecked(
                                                this.allItems!
                                                    .where((element) =>
                                                element.fromDate ==
                                                    dates[this
                                                        .dateIndex!])
                                                    .elementAt(i)
                                                    .fromDate,
                                                box.values.length != 0
                                                    ? chartService.getNumberOfNotChecked(
                                                    box.values.toList(),
                                                    this.allItems!.where((element) => element.fromDate == dates[this.dateIndex!]).elementAt(i).fromDate) - 1 : 0);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            isExpanded: this.allItems!
                                .where((element) =>
                            element.fromDate ==
                                dates[this.dateIndex!])
                                .elementAt(i)
                                .expanded,
                          ),
                    ],
                    expansionCallback: (int item, bool status) {
                      this.allItems!.where((element) => element.fromDate == dates[this.dateIndex!]).elementAt(item).expanded = !status;
                    },
                  ),
                ],
              );
            }),
      ],
    );
  }
}


///ListTile: Description, Frequency, ...
class CostumListTile extends StatelessWidget {

  final Color? color;
  final Size? size;
  final List<DateTime>? dates;
  final int? Index;
  final String? title;
  final String? body;

  const CostumListTile({
    Key? key,
    this.dates,
    this.size,
    this.title,
    this.color,
    this.body,
    this.Index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text(
          this.title! + ": ",
          style: GoogleFonts.kreon(color: this.color, fontSize: 13),
        ),
        Text(
          this.body!,
          style: GoogleFonts.kreon(fontSize: 13),
        ),
      ],
    );
  }
}
