import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';

class PoamList extends StatefulWidget {
  const PoamList({ Key? key }) : super(key: key);

  @override
  _PoamListState createState() => _PoamListState();
}

class _PoamListState extends State<PoamList> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final List items = ["Einkaufliste", "Aufgabenliste"];
    final List itemsIcons = [Icons.fastfood_outlined, Icons.task_alt];
    final List<List<List>> list = [
      [
        ['Tomaten einkaufen', 3],
        ['Chips einkaufen', 2],
        ['Paprika einkaufen', 1],
        ['Klopapier einkaufen', 4],
        ['Gurken einkaufen', 5],
        ['Möhren einkaufen', 3],
      ],
      [
        ['Einkaufen gehen'],
        ['Zimmer aufräumen'],
        ['Hausaufgaben machen'],
        ['Garage putzen'],
      ]
    ];

    return SizedBox(

      width: size.width,

      child: ListView(

        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [

          for (var i = 0; i < items.length; i++) PoamMenu(
            title: items.elementAt(i),
            iconData: itemsIcons.elementAt(i),
            items: list.elementAt(i),
          ),


        ],
      ),
    );
  }
}