import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
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

          ///####################### Its only for demonstrate, when the db is integrated this will be deleted
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel("Zimmer aufräumen", 1, false, Person("Moritz Platen"), Categories.tasks, DateTime(0)));
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel("Gurken holen", 1, false, Person(""), Categories.shopping, DateTime(2022, 2, 12)));
          ///#######################

          ///Navigate to PoamPopUp and add a Provider
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => MenuService(),
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
