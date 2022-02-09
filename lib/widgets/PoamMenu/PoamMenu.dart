import 'package:flutter/material.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:provider/provider.dart';

class PoamMenu extends StatefulWidget {

  final String? title;
  final IconData? iconData;
  final Iterable<dynamic>? onlyFiveItems;
  final bool? isExistsMoreItems;
  final List<dynamic>? allItems;
  final int? numberOfItems;

  const PoamMenu({Key? key, this.title, this.iconData, this.onlyFiveItems, this.isExistsMoreItems, this.allItems, this.numberOfItems }) : super(key: key);

  @override
  _PoamMenuState createState() => _PoamMenuState();
}

class _PoamMenuState extends State<PoamMenu> {

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => {
        setState(() {
          if (widget.allItems!.isEmpty == false) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => MenuService(),
                  ),
                ],
                child: ListPage(
                  category: widget.onlyFiveItems!.first.categories,
                ),
              ),
              ),
            );
          } else {
            final snackBar = SnackBar(
              content: Text("Ihre " + widget.title! + " ist leer!"),
              backgroundColor: primaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
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

          ///TODO: Ein PoamDateItem erzeugen und alle Items die die gleichen Daten haben sollen in einer Liste

          children: [

            Row(
              children: [

                Text(
                  widget.title!,
                  style: const TextStyle(
                      fontSize: 18
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  widget.iconData,
                  size: 18,
                ),

              ],
            ),

            const SizedBox(
              height: 10,
            ),

            for (var i = 0; i < widget.onlyFiveItems!.length; i++) Center(
              child: PoamItem(
                itemIndex: i,
                itemModel: widget.onlyFiveItems!.elementAt(i),
              ),
            ),

            if (widget.isExistsMoreItems == true) Row(
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

                Text("Und weitere Elemente: " + (widget.numberOfItems! - 5).toString()),

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
            if (widget.allItems!.isEmpty == true) const Text("Es sind keine Items vorhanden!"),

          ],
        ),

      ),
    );
  }
}
