import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:provider/provider.dart';

class PoamItem extends StatefulWidget {

  final int? itemIndex;
  final ItemModel? itemModel;

  const PoamItem({ Key? key, this.itemIndex, this.itemModel }) : super(key: key);

  @override
  _PoamItemState createState() => _PoamItemState();
}

class _PoamItemState extends State<PoamItem> {

  late MenuService menuService;

  bool isChecked = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    menuService = MenuService();

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

                  Text(widget.itemModel!.title!),
                  const SizedBox(height: 1,),
                  //Count should only displayed on the Category Shopping
                  if (widget.itemModel!.categories == Categories.shopping) Text("Anzahl: " + widget.itemModel!.count!.toString()),

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
                      widget.itemModel!.date!,
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
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: widget.itemModel!.isChecked!,
              onChanged: (bool? value) {
                setState(() {
                  ///TODO: Remove Item
                  widget.itemModel!.isChecked = value!;
                  Provider.of<MenuService>(context, listen: false).removeItem(widget.itemModel!);
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