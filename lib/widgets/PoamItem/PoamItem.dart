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
    final primaryColor = Theme.of(context).colorScheme.primary;

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
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),


                  if (widget.itemModel!.categories == Categories.tasks)
                  Text(
                    "Bis zum: " + widget.itemModel!.date!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.blue),
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