import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';

class PoamDateItem extends StatefulWidget {

  final Iterable<dynamic>? allItems;
  final Categories? category;

  const PoamDateItem({Key? key, this.allItems, this.category }) : super(key: key);

  @override
  _PoamDateItemState createState() => _PoamDateItemState();
}

class _PoamDateItemState extends State<PoamDateItem> {

  late MenuService menuService;

  @override
  Widget build(BuildContext context) {

    menuService = MenuService();
    List<String> dates = menuService.getListOfAllDates(widget.allItems!);
    Color primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [

        (widget.category! == Categories.shopping) ?
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
            Column(
              children: [
                for(int k = 0;k < dates.length;k++)
                  Column(
                    children: [
                      const SizedBox(height: 6,),
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
                            "Datum: " + dates[k],
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
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
                      for (int i = 0; i < widget.allItems!.length;i++)
                        if (widget.allItems!.elementAt(i).date == dates[k]) PoamItem(
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
