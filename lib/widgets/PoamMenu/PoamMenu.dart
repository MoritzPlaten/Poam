import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';

class PoamMenu extends StatefulWidget {

  final String? title;
  final IconData? iconData;
  final List? items;

  const PoamMenu({Key? key, this.title, this.iconData, this.items }) : super(key: key);

  @override
  _PoamMenuState createState() => _PoamMenuState();
}

class _PoamMenuState extends State<PoamMenu> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(

      width: size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      child: ListView(

        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
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

          for (var i = 0; i < widget.items!.length; i++) Center(
            child: PoamItem(
              item: widget.items!.elementAt(i),
            ),
          ),

        ],
      ),

    );
  }
}
