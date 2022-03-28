import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/itemServices/Objects/Alarms/Alarms.dart';

import '../../services/itemServices/ItemModel.dart';
import '../../services/itemServices/Objects/Database.dart';

typedef void UpdateAlarms(DateTime alarm);

class PoamNotification extends StatefulWidget {

  final UpdateAlarms? addAlarms;
  final UpdateAlarms? removeAlarms;
  final List<DateTime>? listOfAlarms;

  const PoamNotification({ Key? key, this.addAlarms, this.removeAlarms, this.listOfAlarms }) : super(key: key);

  @override
  State<PoamNotification> createState() => _PoamNotificationState();
}

class _PoamNotificationState extends State<PoamNotification> {

  late Color primaryColor;
  late Size size;
  TimeOfDay timeOfDay = TimeOfDay(hour: 0, minute: 0);
  late List<DateTime> alarms;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;
    alarms = List.generate(0, (index) => DateTime(0));

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
              setState(() {

                timeOfDay = picked;
                DateTime pickedDateTime = DateTime(0,0,0,timeOfDay.hour, timeOfDay.minute);
                widget.addAlarms!(pickedDateTime);
              });
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
                              style: GoogleFonts.novaMono(),
                            ),
                            margin: EdgeInsets.only(top: 10),
                          ),

                          for (int i = 0;i < widget.listOfAlarms!.length;i++)
                            SizedBox(

                              width: size.width * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.listOfAlarms!.elementAt(i)),
                                    style: GoogleFonts.novaMono(
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      widget.removeAlarms!(widget.listOfAlarms!.elementAt(i));
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
