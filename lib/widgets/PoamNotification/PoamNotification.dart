import 'package:flutter/material.dart';

class PoamNotification extends StatefulWidget {
  const PoamNotification({Key? key}) : super(key: key);

  @override
  State<PoamNotification> createState() => _PoamNotificationState();
}

class _PoamNotificationState extends State<PoamNotification> {

  @override
  Widget build(BuildContext context) {

    ///TODO: Add surface for notifications

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [

            Column(
              children: [



              ],
            ),

            SizedBox(
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
