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
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/itemServices/Objects/Alarms/Alarms.dart';
import '../../services/itemServices/Objects/Amounts/Amounts.dart';
import '../../services/itemServices/Objects/Amounts/QuantityType.dart';
import '../../services/itemServices/Objects/Database.dart';

class PoamItem extends StatelessWidget {

  final int? itemIndex;
  final ItemModel? itemModel;

  const PoamItem({ Key? key, this.itemIndex, this.itemModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    Size size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

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
                    child: PoamPopUp(itemModel: this.itemModel,isEditMode: true,),
                  )),
                );
              },

              child: Row(
                children: [

                  ///Displays if Categories == Tasks is. Displays the color
                  if (this.itemModel!.categories == Categories.tasks) Container(
                    width: 5,
                    height: 25,
                    decoration: BoxDecoration(
                      color: HexColor(this.itemModel!.hex),
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
                          this.itemModel!.title,
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
                      if (this.itemModel!.categories == Categories.tasks && this.itemModel!.fromTime != this.itemModel!.toTime)
                        Text(
                          AppLocalizations.of(context)!.around + " " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(this.itemModel!.fromTime) +
                              " - " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(this.itemModel!.toTime) + " " + AppLocalizations.of(context)!.clock,
                          style: GoogleFonts.kreon(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ///if fromTime == toTime, then display "fromTime"
                      if (this.itemModel!.categories == Categories.tasks && this.itemModel!.fromTime == this.itemModel!.toTime)
                        Text(
                          AppLocalizations.of(context)!.around + " " + DateFormat.Hm(Localizations.localeOf(context).languageCode).format(this.itemModel!.fromTime) + " " + AppLocalizations.of(context)!.clock,
                          style: GoogleFonts.kreon(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ///Count should only displayed on the Category Shopping
                      if (this.itemModel!.categories == Categories.shopping)
                        Text(
                          AppLocalizations.of(context)!.numberField + ": " +
                              this.itemModel!.amounts.Number.toString() + " " +
                              displayTextQuantityType(context, this.itemModel!.amounts.quantityType!),
                          style: GoogleFonts.kreon(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ///Person should only displayed when the Category Tasks is active
                      if (this.itemModel!.categories == Categories.tasks)
                        SizedBox(
                          width: size.width * 0.4,
                          child: Text(
                            "Person: " + this.itemModel!.person.name.toString(),
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
                    value: this.itemModel!.isChecked,
                    onChanged: (bool? value) async {

                      ChartService chartService = ChartService(0, 0, DateTime(0));

                      if (this.itemModel!.frequency == Frequency.single) {

                        ///ItemModel
                        this.itemModel!.isChecked = value!;
                        Provider.of<ItemModel>(context, listen: false).removeItem(this.itemModel!);

                        ///ChartModel
                        if (this.itemModel!.categories == Categories.tasks) {

                          Provider.of<ChartService>(context, listen: false).putChecked(this.itemModel!.fromDate, chartService.getNumberOfChecked(box.values.toList(), this.itemModel!.fromDate) + 1);
                          Provider.of<ChartService>(context, listen: false).putNotChecked(
                              this.itemModel!.fromDate, box.values.length != 0 ? chartService.getNumberOfNotChecked(box.values.toList(), this.itemModel!.fromDate) - 1 : 0);
                        }
                      } else {

                        if (this.itemModel!.categories == Categories.tasks) {

                          ///ChartModel
                          Provider.of<ChartService>(context, listen: false)
                              .putChecked(
                              this.itemModel!.fromDate, chartService
                              .getNumberOfChecked(
                              box.values.toList(), this.itemModel!.fromDate) +
                              1);
                          Provider.of<ChartService>(context, listen: false)
                              .putNotChecked(
                              this.itemModel!.fromDate, box.values.length != 0
                              ? chartService.getNumberOfNotChecked(
                              box.values.toList(), this.itemModel!.fromDate) -
                              1
                              : 0);

                          DateTime fromDate = this.itemModel!.fromDate;
                          DateTime toDate = this.itemModel!.toDate;
                          DateTime? _fromDate;
                          DateTime? _toDate;

                          ///ItemModel
                          ///Set the Date to a new Date
                          switch(this.itemModel!.frequency) {

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
                            case Frequency.single:
                              ///empty
                              break;
                          }

                          ///ChartModel add new DateTime
                          Provider.of<ChartService>(context, listen: false)
                              .putNotChecked(_fromDate!, chartService.getNumberOfNotChecked(box.values.toList(), _fromDate) + 1);

                          ///Create the new ItemModel
                          Provider.of<ItemModel>(context, listen: false).addItem(
                              new ItemModel(
                                  this.itemModel!.title,
                                  this.itemModel!.amounts,
                                  this.itemModel!.isChecked,
                                  this.itemModel!.person,
                                  this.itemModel!.categories,
                                  this.itemModel!.hex,
                                  this.itemModel!.fromTime,
                                  _fromDate,
                                  this.itemModel!.toTime,
                                  _toDate!,
                                  this.itemModel!.frequency,
                                  this.itemModel!.description,
                                  this.itemModel!.alarms,
                                  this.itemModel!.expanded
                              )
                          );

                          ///Remove the Old ItemModel
                          Provider.of<ItemModel>(context, listen: false).removeItem(this.itemModel!);
                        }
                      }
                    },
                  );
                }),
          ),

        ],
      ),

    );
  }
}
