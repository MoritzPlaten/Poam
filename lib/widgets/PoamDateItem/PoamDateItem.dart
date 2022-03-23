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

class PoamDateItem extends StatefulWidget {
  final Iterable<ItemModel>? allItems;
  final Categories? categories;
  final int? dateIndex;

  const PoamDateItem({Key? key, this.allItems, this.categories, this.dateIndex})
      : super(key: key);

  @override
  _PoamDateItemState createState() => _PoamDateItemState();
}

class _PoamDateItemState extends State<PoamDateItem> {
  late DateService dateService;
  late List<DateTime> dates;
  late Color primaryColor;
  late String languageCode;
  late Size size;
  late Brightness brightness;

  @override
  Widget build(BuildContext context) {
    ///initialize
    dateService = DateService();
    brightness = MediaQuery.of(context).platformBrightness;
    dates = dateService.getListOfAllDates(widget.allItems!
        .where((element) => element.categories == Categories.tasks));
    primaryColor = Theme.of(context).primaryColor;
    size = size = MediaQuery.of(context).size;

    return Column(
      children: [
        ///Display a Column, when the Category shopping is
        (widget.categories! == Categories.shopping)
            ? ExpansionPanelList(
                elevation: 0,
                children: [
                  for (int i = 0; i < widget.allItems!.length; i++)
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return PoamItem(
                          itemIndex: i,
                          itemModel: widget.allItems!.elementAt(i),
                        );
                      },
                      body: Column(
                        children: [
                          ///Displays Description of Shopping elements
                          if (widget.allItems!
                                  .elementAt(widget.dateIndex!)
                                  .description !=
                              "")
                            CostumListTile(
                              color: primaryColor,
                              size: size,
                              dates: dates,
                              Index: i,
                              title: AppLocalizations.of(context)!
                                  .descriptionField,
                              body: widget.allItems!.elementAt(i).description,
                            ),
                        ],
                      ),
                      isExpanded: widget.allItems!.elementAt(i).expanded,
                    ),
                ],
                expansionCallback: (int item, bool status) {
                  if (!widget.allItems!.elementAt(item).description.isEmpty) {
                    widget.allItems!.elementAt(item).expanded = !status;
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
                                      .format(dates[widget.dateIndex!]) +
                                  " - " +
                                  DateFormat.yMd(Localizations.localeOf(context)
                                          .languageCode)
                                      .format(dates[widget.dateIndex!]),
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
                                  widget.allItems!
                                      .where((element) =>
                                          element.fromDate ==
                                          dates[widget.dateIndex!])
                                      .length;
                              i++)
                            if (DateTime(
                                    widget.allItems!
                                        .where((element) =>
                                            element.fromDate ==
                                            dates[widget.dateIndex!])
                                        .elementAt(i)
                                        .fromDate
                                        .year,
                                    widget.allItems!
                                        .where((element) =>
                                            element.fromDate ==
                                            dates[widget.dateIndex!])
                                        .elementAt(i)
                                        .fromDate
                                        .month,
                                    widget.allItems!
                                        .where((element) =>
                                            element.fromDate ==
                                            dates[widget.dateIndex!])
                                        .elementAt(i)
                                        .fromDate
                                        .day) ==
                                dates[widget.dateIndex!])
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  ///Displays the PoamItem
                                  return PoamItem(
                                    itemIndex: i,
                                    itemModel: widget.allItems!
                                        .where((element) =>
                                            element.fromDate ==
                                            dates[widget.dateIndex!])
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
                                            if (widget.allItems!
                                                    .where((element) =>
                                                        element.fromDate ==
                                                        dates[
                                                            widget.dateIndex!])
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
                                                    widget.allItems!
                                                        .where((element) =>
                                                            element.fromDate ==
                                                            dates[widget
                                                                .dateIndex!])
                                                        .elementAt(i)
                                                        .frequency),
                                              ),

                                            const SizedBox(
                                              height: 6,
                                            ),

                                            ///Displays the Description
                                            if (widget.allItems!
                                                    .where((element) =>
                                                        element.fromDate ==
                                                        dates[
                                                            widget.dateIndex!])
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
                                                body: widget.allItems!
                                                    .where((element) =>
                                                        element.fromDate ==
                                                        dates[
                                                            widget.dateIndex!])
                                                    .elementAt(i)
                                                    .description
                                                    .trim(),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (widget.allItems!
                                              .where((element) =>
                                                  element.fromDate ==
                                                  dates[widget.dateIndex!])
                                              .elementAt(i)
                                              .frequency !=
                                          Frequency.single)

                                        ///Delete Button: displays if the frequency != single
                                        Flexible(
                                          flex: 1,
                                          child: IconButton(
                                            onPressed: () {

                                              ///ItemModel
                                              widget.allItems!
                                                      .where(
                                                          (element) =>
                                                              element
                                                                  .fromDate ==
                                                              dates[widget
                                                                  .dateIndex!])
                                                      .elementAt(i)
                                                      .isChecked =
                                                  !widget.allItems!
                                                      .where((element) =>
                                                          element.fromDate ==
                                                          dates[widget
                                                              .dateIndex!])
                                                      .elementAt(i)
                                                      .isChecked;
                                              Provider.of<ItemModel>(context,
                                                      listen: false)
                                                  .removeItem(widget.allItems!
                                                      .where((element) =>
                                                          element.fromDate ==
                                                          dates[widget
                                                              .dateIndex!])
                                                      .elementAt(i));

                                              ///ChartModel
                                              if (widget.allItems!
                                                      .where((element) =>
                                                          element.fromDate ==
                                                          dates[widget
                                                              .dateIndex!])
                                                      .elementAt(i)
                                                      .categories ==
                                                  Categories.tasks) {
                                                ChartService chartService =
                                                    ChartService(
                                                        0, 0, DateTime(0));

                                                Provider.of<ChartService>(context, listen: false).putNotChecked(
                                                    widget.allItems!
                                                        .where((element) =>
                                                            element.fromDate ==
                                                            dates[widget
                                                                .dateIndex!])
                                                        .elementAt(i)
                                                        .fromDate,
                                                    box.values.length != 0
                                                        ? chartService.getNumberOfNotChecked(
                                                                box.values.toList(),
                                                        widget.allItems!.where((element) => element.fromDate == dates[widget.dateIndex!]).elementAt(i).fromDate) - 1 : 0);
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
                                isExpanded: widget.allItems!
                                    .where((element) =>
                                element.fromDate ==
                                    dates[widget.dateIndex!])
                                    .elementAt(i)
                                    .expanded,
                              ),
                        ],
                        expansionCallback: (int item, bool status) {
                          widget.allItems!.where((element) => element.fromDate == dates[widget.dateIndex!]).elementAt(item).expanded = !status;
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
class CostumListTile extends StatefulWidget {
  final Color? color;
  final Size? size;
  final List<DateTime>? dates;
  final int? Index;
  final String? title;
  final String? body;

  const CostumListTile(
      {Key? key,
      this.dates,
      this.size,
      this.title,
      this.color,
      this.body,
      this.Index})
      : super(key: key);

  @override
  State<CostumListTile> createState() => _CostumListTileState();
}

class _CostumListTileState extends State<CostumListTile> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    ///initialize
    size = MediaQuery.of(context).size;

    return Row(
      children: [
        Text(
          widget.title! + ": ",
          style: GoogleFonts.kreon(color: widget.color, fontSize: 13),
        ),
        Text(
          widget.body!,
          style: GoogleFonts.kreon(fontSize: 13),
        ),
      ],
    );
  }
}
