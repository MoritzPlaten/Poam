import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamPopUp/PoamPopUp.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late PoamSnackbar poamSnackbar;
  
  @override
  Widget build(BuildContext context) {

    ///initialize
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    poamSnackbar = PoamSnackbar();

    return Container(

      width: size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Flexible(
                flex: 4,
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (_) => ItemModel("", 0, false, Person(""), Categories.shopping, "", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", false),
                            ),
                            ChangeNotifierProvider(
                              create: (_) => Person(""),
                            ),
                          ],
                          ///EditMode true
                          child: PoamPopUp(itemModel: widget.itemModel,isEditMode: true,),
                        )),
                      );

                    });
                  },

                  child: Row(
                    children: [

                      ///Displays if Categories == Tasks is. Displays the color
                      if (widget.itemModel!.categories == Categories.tasks) Container(
                        width: 5,
                        height: 25,
                        decoration: BoxDecoration(
                          color: HexColor(widget.itemModel!.hex),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ///Display the Item Title
                          SizedBox(
                            width: size.width * 0.40,
                            child: Text(
                              widget.itemModel!.title,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.5
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(height: 1,),

                          ///TODO: width kann so lang sein, muss angepasst werden
                          ///if fromTime != toTime, then display "fromTime - toTime Uhr"
                          if (widget.itemModel!.categories == Categories.tasks && widget.itemModel!.fromTime != widget.itemModel!.toTime)
                            Text(
                              AppLocalizations.of(context)!.around + " " + widget.itemModel!.fromTime.hour.toString() + ":" + widget.itemModel!.fromTime.minute.toString() +
                                  " - " + widget.itemModel!.toTime.hour.toString() + ":" + widget.itemModel!.toTime.minute.toString() + " " + AppLocalizations.of(context)!.clock,
                              style: GoogleFonts.kreon(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ///if fromTime == toTime, then display "fromTime"
                          if (widget.itemModel!.categories == Categories.tasks && widget.itemModel!.fromTime == widget.itemModel!.toTime)
                            Text(
                              AppLocalizations.of(context)!.around + " " + widget.itemModel!.fromTime.hour.toString() + ":" + widget.itemModel!.fromTime.minute.toString() + " " + AppLocalizations.of(context)!.clock,
                              style: GoogleFonts.kreon(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

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
                            SizedBox(
                              ///TODO: size anpassen von Person
                              width: size.width * 0.4,
                              child: Text(
                                "Person: " + widget.itemModel!.person.name.toString(),
                                style: GoogleFonts.kreon(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              ///ShaderMask for the look
              Flexible(
                flex: 1,
                child: Checkbox(
                  checkColor: primaryColor,
                  fillColor: MaterialStateProperty.all(primaryColor),
                  value: widget.itemModel!.isChecked,
                  onChanged: (bool? value) {
                    ///TODO: if Frequency != Single then don't remove the Item from db, but remove only the surface and for this week
                    if (widget.itemModel!.frequency == Frequency.single) {
                      widget.itemModel!.isChecked = value!;
                      Provider.of<ItemModel>(context, listen: false).removeItem(widget.itemModel!);
                    } else {
                      ///TODO: Remove surface and for this day but not
                      poamSnackbar.showSnackBar(context,
                          "Item soll nicht entfernt werden von der Datenbank, sondern nur die Oberfläche für den Tag!",
                          primaryColor);
                    }
                  },
                ),
              ),

            ],
          ),

    );
  }
}