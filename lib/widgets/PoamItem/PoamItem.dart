import 'package:flutter/material.dart';

class PoamItem extends StatefulWidget {

  final Map? item;
  const PoamItem({ Key? key, this.item }) : super(key: key);

  @override
  _PoamItemState createState() => _PoamItemState();
}

class _PoamItemState extends State<PoamItem> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    bool isChecked = false;

    return Container(

      width: size.width,
      padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item!["Title"]),
                  const SizedBox(height: 1,),
                  if (widget.item!["Anzahl"] != null) Text("Anzahl: " + widget.item!["Anzahl"].toString()),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const RadialGradient(
                        center: Alignment.topLeft,
                        radius: 5,
                        colors: <Color>[Colors.red, Colors.blue],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    child: Text(
                      widget.item!["Created"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),

              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),

            ],
          ),

        ],
      ),

    );
  }
}