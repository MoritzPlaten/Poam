import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/dateServices/DateService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamDateItem extends StatefulWidget {

  final Iterable<ItemModel>? allItems;
  final Categories? categories;

  const PoamDateItem({Key? key, this.allItems, this.categories }) : super(key: key);

  @override
  _PoamDateItemState createState() => _PoamDateItemState();
}

class _PoamDateItemState extends State<PoamDateItem> {

  late DateService dateService;
  late List<DateTime> dates;
  late Color primaryColor;

  @override
  Widget build(BuildContext context) {

    ///initialize
    dateService = DateService();
    dates = dateService.getListOfAllDates(widget.allItems!.where((element) => element.categories == Categories.tasks));
    primaryColor = Theme.of(context).primaryColor;

    //print(widget.allItems!.where((element) => element.categories == Categories.tasks));
    //print(itemsState);
    //print(dates.length);

    return Column(
      children: [

        ///Display a Column, when the Category shopping is
        (widget.categories! == Categories.shopping) ?
            ///TODO: Fix Problem
            ExpansionPanelList(
              elevation: 0,
              children: [
                for (int i = 0; i < widget.allItems!.length;i++)
                  ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return PoamItem(
                          itemIndex: i,
                          itemModel: widget.allItems!.elementAt(i),
                        );
                      },
                      body: Column(
                        children: [
                          if (widget.allItems!.where((element) =>
                          element.categories == Categories.shopping).elementAt(i).description != "")
                            Text(
                              "Beschreibung: " + widget.allItems!.where((element) =>
                              element.categories == Categories.shopping).elementAt(i).description,
                              style: GoogleFonts.novaMono(
                                  fontSize: 12
                              ),
                            ),
                        ],
                      ),
                    isExpanded: widget.allItems!.where((element) => element.categories == Categories.shopping).elementAt(i).expanded,
                  ),
              ],
              expansionCallback: (int item, bool status) {
                setState(() {
                  widget.allItems!.where((element) => element.categories == Categories.shopping).elementAt(item).expanded = !status;
                });
              },
            )
            :
            ///Display the Items with the Date
            Column(
              children: [
                for(int k = 0;k < dates.length;k++)
                  Column(
                    children: [
                      const SizedBox(height: 2,),
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
                              DateFormat("EEEE - dd.MM.yyyy").format(dates[k]),
                            style: GoogleFonts.novaMono(
                              fontSize: 11,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            )
                          ),

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
                      /*for (int i = 0; i < widget.allItems!.length;i++)
                        if (DateTime(widget.allItems!.elementAt(i).date.year,
                            widget.allItems!.elementAt(i).date.month,
                            widget.allItems!.elementAt(i).date.day) == dates[k])
                          PoamItem(
                          itemIndex: i,
                          itemModel: widget.allItems!.elementAt(i),
                          ),*/
                      ///TODO: Fix Problem
                      ExpansionPanelList(
                        elevation: 0,
                        children: [

                          for (int i = 0; i < widget.allItems!.length;i++)
                            if (DateTime(widget.allItems!.elementAt(i).fromDate.year,
                                widget.allItems!.elementAt(i).fromDate.month,
                                widget.allItems!.elementAt(i).fromDate.day) == dates[k])
                              ExpansionPanel(
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return PoamItem(
                                    itemIndex: i,
                                    itemModel: widget.allItems!.elementAt(i),
                                  );
                                },
                                body: Column(
                                  children: [
                                    if (widget.allItems!.elementAt(i).description != "")
                                      Text(
                                        "Beschreibung: " + widget.allItems!.elementAt(i).description,
                                        style: GoogleFonts.novaMono(
                                          fontSize: 12
                                        ),
                                      ),
                                  ],
                                ),
                                isExpanded: widget.allItems!.elementAt(i).expanded,
                                //canTapOnHeader: true,
                              ),
                        ],
                        expansionCallback: (int item, bool status) {
                          setState(() {

                            widget.allItems!.where((element) =>
                            element.fromDate == dates[k]).elementAt(item).expanded = !status;
                          });
                        },
                      ),

                    ],
                  ),
              ],
            ),
      ],
    );
  }
}
