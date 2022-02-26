import 'package:flutter/material.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamPopUp/PoamPopUp.dart';
import 'package:provider/provider.dart';

class PoamFloatingButton extends StatefulWidget {

  const PoamFloatingButton({Key? key }) : super(key: key);

  @override
  _PoamFloatingButtonState createState() => _PoamFloatingButtonState();
}

class _PoamFloatingButtonState extends State<PoamFloatingButton> {

  late Color primaryColor;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton(
      onPressed: () => {
        setState(() {

          ///Navigate to PoamPopUp and add a Provider
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ItemModel("", 0, false, Person(""), Categories.tasks, "0xFFFFFF", DateTime(0), DateTime(0), Frequency.single, ""),
                ),
                ChangeNotifierProvider(
                  create: (_) => ChartService(),
                ),
                ChangeNotifierProvider(
                  create: (_) => Person(""),
                ),
              ],
              child: const PoamPopUp(),
            )
            ),
          );

        })
      },
      child: Container(
        width: 60,
        height: 60,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            radius: 0.9,
            center: const Alignment(0.7, -0.6),
            colors: [primaryColor, primaryColor.withRed(180).withBlue(140)],
            stops: const [0.1, 0.8]
          ),
        ),
      ),
    );
  }
}
