import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class PoamItem extends StatefulWidget {

  final int? itemIndex;
  final ItemModel? itemModel;

  const PoamItem({ Key? key, this.itemIndex, this.itemModel }) : super(key: key);

  @override
  _PoamItemState createState() => _PoamItemState();
}

class _PoamItemState extends State<PoamItem> {

  late Size size;
  late Color primaryColor;
  
  @override
  Widget build(BuildContext context) {

    ///initialize
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;

    return Container(

      width: size.width,
      padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [

                  Container(
                    width: 5,
                    height: 25,
                    decoration: BoxDecoration(
                      color: HexColor(widget.itemModel!.hex),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ///Display the Item Title
                      Text(
                        widget.itemModel!.title,
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.5
                        ),
                      ),
                      const SizedBox(height: 1,),

                      ///Count should only displayed on the Category Shopping
                      if (widget.itemModel!.categories == Categories.shopping)
                        Text(
                          "Anzahl: " + widget.itemModel!.count.toString(),
                          style: GoogleFonts.kreon(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ///Person should only displayed when the Category Tasks is active
                      if (widget.itemModel!.categories == Categories.tasks)
                        Text(
                          "Person: " + widget.itemModel!.person.name.toString(),
                          style: GoogleFonts.kreon(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                    ],
                  ),

                ],
              ),

              ///ShaderMask for the look
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
                  value: widget.itemModel!.isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.itemModel!.isChecked = value!;
                      Provider.of<ItemModel>(context, listen: false).removeItem(widget.itemModel!);
                    });
                  },
                ),
              ),

            ],
          ),

    );
  }
}