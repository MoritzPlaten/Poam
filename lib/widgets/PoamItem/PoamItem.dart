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
  
  @override
  Widget build(BuildContext context) {

    menuService = MenuService();

    final sizeOfItem = Size(0,0);
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

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

                  Text(
                      widget.itemModel!.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                    ),
                  ),
                  const SizedBox(height: 1,),
                  //Count should only displayed on the Category Shopping
                  if (widget.itemModel!.categories == Categories.shopping)
                  Text(
                      "Anzahl: " + widget.itemModel!.count!.toString(),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),


                  if (widget.itemModel!.categories == Categories.tasks)
                  Text(
                    "Bis zum: " + widget.itemModel!.date!,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.0,
                    colors: <Color>[primaryColor, primaryColor.withRed(180).withBlue(140)],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  value: widget.itemModel!.isChecked!,
                  onChanged: (bool? value) {
                    setState(() {
                      ///TODO: Remove Item
                      widget.itemModel!.isChecked = value!;
                      Provider.of<MenuService>(context, listen: false).removeItem(widget.itemModel!);
                    });
                  },
                ),
              ),

            ],
          ),


        ],
      ),

    );
  }
}