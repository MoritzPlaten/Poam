import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    ///initialize
    dateService = DateService();
    dates = dateService.getListOfAllDates(widget.allItems!
        .where((element) => element.categories == Categories.tasks));
    primaryColor = Theme.of(context).primaryColor;
    size = size = MediaQuery.of(context).size;

    return Column(
      children: [
        ///Display a Column, when the Category shopping is
        (widget.categories! == Categories.shopping)
            ?

            ///TODO: Ändern zu ExpansionList, ...
            ExpansionPanelList(
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
                                  .where((element) =>
                                      element.categories == Categories.shopping)
                                  .elementAt(i)
                                  .description !=
                              "")
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                          .descriptionField +
                                      ": ",
                                  style: GoogleFonts.kreon(
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: size.width - (size.width / 2.3),
                                  child: Text(
                                    widget.allItems!
                                        .where((element) =>
                                            element.categories ==
                                            Categories.shopping)
                                        .elementAt(i)
                                        .description,
                                    style: GoogleFonts.kreon(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      isExpanded: widget.allItems!.elementAt(i).expanded,
                    ),
                ],
                expansionCallback: (int item, bool status) {
                  widget.allItems!.elementAt(item).expanded = !status;
                },
              )
            :

            ///Display the Items with the Date
            Column(
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
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      ///Displays the frequency
                                      if (widget.allItems!
                                              .where((element) =>
                                                  element.fromDate ==
                                                  dates[widget.dateIndex!])
                                              .elementAt(i)
                                              .frequency !=
                                          "")
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                      .frequency +
                                                  ": ",
                                              style: GoogleFonts.kreon(
                                                  color: primaryColor,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              width:
                                                  size.width - (size.width / 2),
                                              child: Text(
                                                displayFrequency(
                                                    context,
                                                    widget.allItems!
                                                        .where((element) =>
                                                            element.fromDate ==
                                                            dates[widget
                                                                .dateIndex!])
                                                        .elementAt(i)
                                                        .frequency),
                                                style: GoogleFonts.kreon(
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      ///Displays the Description
                                      if (widget.allItems!
                                              .where((element) =>
                                                  element.fromDate ==
                                                  dates[widget.dateIndex!])
                                              .elementAt(i)
                                              .description !=
                                          "")
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                      .descriptionField +
                                                  ": ",
                                              style: GoogleFonts.kreon(
                                                  color: primaryColor,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              width:
                                                  size.width - (size.width / 2),
                                              child: Text(
                                                widget.allItems!
                                                    .where((element) =>
                                                        element.fromDate ==
                                                        dates[
                                                            widget.dateIndex!])
                                                    .elementAt(i)
                                                    .description,
                                                style: GoogleFonts.kreon(
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  if (widget.allItems!
                                          .where((element) =>
                                              element.fromDate ==
                                              dates[widget.dateIndex!])
                                          .elementAt(i)
                                          .frequency !=
                                      Frequency.single)
                                    IconButton(
                                      onPressed: () {
                                        widget.allItems!
                                                .where((element) =>
                                                    element.fromDate ==
                                                    dates[widget.dateIndex!])
                                                .elementAt(i)
                                                .isChecked =
                                            !widget.allItems!
                                                .where((element) =>
                                                    element.fromDate ==
                                                    dates[widget.dateIndex!])
                                                .elementAt(i)
                                                .isChecked;
                                        Provider.of<ItemModel>(context,
                                                listen: false)
                                            .removeItem(widget.allItems!
                                                .where((element) =>
                                                    element.fromDate ==
                                                    dates[widget.dateIndex!])
                                                .elementAt(i));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
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
                      widget.allItems!
                          .where((element) =>
                              element.fromDate == dates[widget.dateIndex!])
                          .elementAt(item)
                          .expanded = !status;
                    },
                  ),
                ],
              ),
      ],
    );
  }
}
