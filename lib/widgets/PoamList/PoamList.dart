import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamItem/PoamItem.dart';
import 'package:poam/widgets/PoamMenu/PoamMenu.dart';
import 'package:intl/intl.dart';

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

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM. | kk:mm').format(now);

    final List<List<Map>> list = [
      [
        {"Title": "Tomaten einkaufen", "Anzahl": 3, "Created": formattedDate},
        {"Title": "Chips einkaufen", "Anzahl": 2, "Created": formattedDate},
        {"Title": "Paprika einkaufen", "Anzahl": 1, "Created": formattedDate},
        {"Title": "Klopapier einkaufen", "Anzahl": 4, "Created": formattedDate},
        {"Title": "Gurken einkaufen", "Anzahl": 5, "Created": formattedDate},
        {"Title": "Möhren einkaufen", "Anzahl": 3, "Created": formattedDate},
      ],
      [
        {"Title": "Einkaufen gehen", "Created": formattedDate},
        {"Title": "Zimmer aufräumen", "Created": formattedDate},
        {"Title": "Hausaufgaben machen", "Created": formattedDate},
        {"Title": "Garage putzen", "Created": formattedDate},
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