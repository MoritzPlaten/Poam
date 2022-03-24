import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../services/itemServices/ItemModel.dart';
import '../../services/itemServices/Objects/Database.dart';

class PoamNotification extends StatefulWidget {

  const PoamNotification({ Key? key }) : super(key: key);

  @override
  State<PoamNotification> createState() => _PoamNotificationState();
}

class _PoamNotificationState extends State<PoamNotification> {

  late Color primaryColor;
  late Size size;
  TimeOfDay timeOfDay = TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) {

    ///TODO: Add surface for notifications

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
        valueListenable: Hive.box<ItemModel>(Database.Name).listenable(),
        builder: (BuildContext context, Box<ItemModel> box, widgets) {

          ///Opens TimePicker
          /*Future<Null> _selectTime(BuildContext context) async {

            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
            );
            if (picked != null)
              setState(() {

                timeOfDay = picked;
                box.values.alarms.listOfAlarms.add(DateTime(0,0,0,timeOfDay.hour, timeOfDay.minute));
              });
          }*/

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

                          Text(
                            AppLocalizations.of(context)!.notification,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.novaMono(),
                          ),

                          /*for (int i = 0;i < widget.itemModel!.alarms.listOfAlarms.length;i++)
                            Text(DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.itemModel!.alarms.listOfAlarms[i])),*/

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
                        //_selectTime(context);
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
