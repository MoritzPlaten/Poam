import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../services/itemServices/ItemModel.dart';
import '../../services/itemServices/Objects/Database.dart';

typedef void UpdateAlarms(DateTime alarm);

class PoamNotification extends StatelessWidget {

  final UpdateAlarms? addAlarms;
  final UpdateAlarms? removeAlarms;
  final List<DateTime>? listOfAlarms;
  late TimeOfDay timeOfDay = TimeOfDay(hour: 0, minute: 0);

  PoamNotification({ Key? key, this.addAlarms, this.removeAlarms, this.listOfAlarms }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    Color primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
        valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
        builder: (BuildContext context, Box<ItemModel> box, widgets) {

          ///Opens TimePicker
          Future<Null> _selectTime(BuildContext context) async {

            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
            );
            if (picked != null)
              timeOfDay = picked;
              DateTime pickedDateTime = DateTime(0,0,0,timeOfDay.hour, timeOfDay.minute);
              this.addAlarms!(pickedDateTime);
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [

                  new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 50.0,
                    ),
                    child: SizedBox(
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            child: Text(
                              AppLocalizations.of(context)!.notification,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Mona",
                              ),
                            ),
                            margin: EdgeInsets.only(top: 10),
                          ),

                          for (int i = 0;i < this.listOfAlarms!.length;i++)
                            SizedBox(

                              width: size.width * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    DateFormat.Hm(Localizations.localeOf(context).languageCode).format(this.listOfAlarms!.elementAt(i)) + " h",
                                    style: TextStyle(fontFamily: "Mona")
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      this.removeAlarms!(this.listOfAlarms!.elementAt(i));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )

                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      backgroundColor: primaryColor,
                      onPressed: () {
                        _selectTime(context);
                      },
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}

