import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/itemServices/ItemModel.dart';

class PoamNotification extends StatefulWidget {

  final ItemModel? itemModel;

  const PoamNotification({ Key? key, this.itemModel }) : super(key: key);

  @override
  State<PoamNotification> createState() => _PoamNotificationState();
}

class _PoamNotificationState extends State<PoamNotification> {

  late Color primaryColor;
  late Size size;

  @override
  Widget build(BuildContext context) {

    ///TODO: Add surface for notifications

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

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

                ],
              ),
            ),
          ),

            Positioned(
              bottom: 0,
              height: 40,
              width: 40,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {

                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
