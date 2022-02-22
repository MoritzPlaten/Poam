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
    dates = dateService.getListOfAllDates(widget.allItems!);
    primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [

        ///Display a Column, when the Category shopping is
        (widget.categories! == Categories.shopping) ?
            Column(
              children: [
                for (int i = 0; i < widget.allItems!.length;i++)
                  PoamItem(
                    itemIndex: i,
                    itemModel: widget.allItems!.elementAt(i),
                  ),
              ],
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

                          Flexible(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey.shade400,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),

                          Text(
                              DateFormat("dd.MM.yyyy").format(dates[k]),
                            style: GoogleFonts.novaMono(
                              fontSize: 11,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            )
                          ),

                          Flexible(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey.shade400,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),

                        ],
                      ),
                      ///Adds all Items with the correct date to the element
                      for (int i = 0; i < widget.allItems!.length;i++)
                          if (widget.allItems!.elementAt(i).date == dates[k])
                            PoamItem(
                            itemIndex: i,
                            itemModel: widget.allItems!.elementAt(i),
                          ),
                    ],
                  )
              ],
            )
      ],
    );
  }
}
