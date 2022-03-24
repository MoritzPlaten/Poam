import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:poam/widgets/PoamPopUp/PoamPopUp.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/itemServices/Objects/Alarms/Alarms.dart';
import '../../services/itemServices/Objects/Amounts/Amounts.dart';
import '../../services/itemServices/Objects/Amounts/QuantityType.dart';
import '../../services/itemServices/Objects/Database.dart';

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
        color: Colors.white,
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
                              create: (_) => ItemModel("", Amounts(0, QuantityType.Pieces), false, Person(""), Categories.shopping, "", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", Alarms([]), false),
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

                          ///if fromTime != toTime, then display "fromTime - toTime Uhr"
                          if (widget.itemModel!.categories == Categories.tasks && widget.itemModel!.fromTime != widget.itemModel!.toTime)
                            Text(
                              AppLocalizations.of(context)!.around + " " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.itemModel!.fromTime) +
                                  " - " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.itemModel!.toTime) + " " + AppLocalizations.of(context)!.clock,
                              style: GoogleFonts.kreon(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ///if fromTime == toTime, then display "fromTime"
                          if (widget.itemModel!.categories == Categories.tasks && widget.itemModel!.fromTime == widget.itemModel!.toTime)
                            Text(
                              AppLocalizations.of(context)!.around + " " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.itemModel!.fromTime) + " " + AppLocalizations.of(context)!.clock,
                              style: GoogleFonts.kreon(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ///Count should only displayed on the Category Shopping
                          if (widget.itemModel!.categories == Categories.shopping)
                            Text(
                              AppLocalizations.of(context)!.numberField + ": " +
                                  widget.itemModel!.amounts.Number.toString() + " " +
                                  displayTextQuantityType(context, widget.itemModel!.amounts.quantityType!),
                              style: GoogleFonts.kreon(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ///Person should only displayed when the Category Tasks is active
                          if (widget.itemModel!.categories == Categories.tasks)
                            SizedBox(
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
                child: ValueListenableBuilder(
                    valueListenable: Hive.box<ChartService>(Database.ChartName).listenable(),
                    builder: (BuildContext context, Box<ChartService> box, widgets) {
                  return Checkbox(
                    checkColor: primaryColor,
                    fillColor: MaterialStateProperty.all(primaryColor),
                    value: widget.itemModel!.isChecked,
                    onChanged: (bool? value) async {

                      ChartService chartService = ChartService(0, 0, DateTime(0));

                      if (widget.itemModel!.frequency == Frequency.single) {

                        ///ItemModel
                        widget.itemModel!.isChecked = value!;
                        Provider.of<ItemModel>(context, listen: false).removeItem(widget.itemModel!);

                        ///ChartModel
                        if (widget.itemModel!.categories == Categories.tasks) {

                          Provider.of<ChartService>(context, listen: false).putChecked(widget.itemModel!.fromDate, chartService.getNumberOfChecked(box.values.toList(), widget.itemModel!.fromDate) + 1);
                          Provider.of<ChartService>(context, listen: false).putNotChecked(
                              widget.itemModel!.fromDate, box.values.length != 0 ? chartService.getNumberOfNotChecked(box.values.toList(), widget.itemModel!.fromDate) - 1 : 0);
                        }
                      } else {

                        if (widget.itemModel!.categories == Categories.tasks) {

                          ///ChartModel
                          Provider.of<ChartService>(context, listen: false)
                              .putChecked(
                              widget.itemModel!.fromDate, chartService
                              .getNumberOfChecked(
                              box.values.toList(), widget.itemModel!.fromDate) +
                              1);
                          Provider.of<ChartService>(context, listen: false)
                              .putNotChecked(
                              widget.itemModel!.fromDate, box.values.length != 0
                              ? chartService.getNumberOfNotChecked(
                              box.values.toList(), widget.itemModel!.fromDate) -
                              1
                              : 0);

                          DateTime fromDate = widget.itemModel!.fromDate;
                          DateTime toDate = widget.itemModel!.toDate;
                          DateTime? _fromDate;
                          DateTime? _toDate;

                          ///ItemModel
                          ///Set the Date to a new Date
                          switch(widget.itemModel!.frequency) {

                            case Frequency.daily:
                              _fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day + 1);
                              _toDate = DateTime(toDate.year, toDate.month, toDate.day + 1);
                              break;

                            case Frequency.weekly:
                              _fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day + 7);
                              _toDate = DateTime(toDate.year, toDate.month, toDate.day + 7);
                              break;

                            case Frequency.monthly:
                              _fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day + 28);
                              _toDate = DateTime(toDate.year, toDate.month, toDate.day + 28);
                              break;

                            case Frequency.yearly:
                              _fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day + 365);
                              _toDate = DateTime(toDate.year, toDate.month, toDate.day + 365);
                              break;
                          }

                          ///Create the new ItemModel
                          Provider.of<ItemModel>(context, listen: false).addItem(
                              new ItemModel(
                                  widget.itemModel!.title,
                                  widget.itemModel!.amounts,
                                  widget.itemModel!.isChecked,
                                  widget.itemModel!.person,
                                  widget.itemModel!.categories,
                                  widget.itemModel!.hex,
                                  widget.itemModel!.fromTime,
                                  _fromDate!,
                                  widget.itemModel!.toTime,
                                  _toDate!,
                                  widget.itemModel!.frequency,
                                  widget.itemModel!.description,
                                  ///TODO: Hier das ändern
                                  Alarms([]),
                                  widget.itemModel!.expanded
                              )
                          );

                          ///Remove the Old ItemModel
                          Provider.of<ItemModel>(context, listen: false).removeItem(widget.itemModel!);
                        }
                      }
                    },
                  );
                }
                ),
              ),

            ],
          ),

    );
  }
}