import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PoamItem extends StatefulWidget {

  final List? item;
  const PoamItem({ Key? key, this.item }) : super(key: key);

  @override
  _PoamItemState createState() => _PoamItemState();
}

class _PoamItemState extends State<PoamItem> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM. | kk:mm').format(now);

    return Container(

      width: size.width,
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        children: [

          Row(
            children: [
              Text(widget.item!.elementAt(0).toString()),
              const SizedBox(width: 10,),
              Text(
                formattedDate.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.deepPurpleAccent
                ),
              )
            ],
          ),

        ],
      ),

    );
  }
}