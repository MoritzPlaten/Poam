import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamPopUp/PoamPopUp.dart';
import 'package:provider/provider.dart';

class PoamFloatingButton extends StatefulWidget {
  const PoamFloatingButton({Key? key}) : super(key: key);

  @override
  _PoamFloatingButtonState createState() => _PoamFloatingButtonState();
}

class _PoamFloatingButtonState extends State<PoamFloatingButton> {

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton(
      //backgroundColor: primaryColor,
      onPressed: () => {
        setState(() {

          //####################### Its only for demonstrate, when the db is integrated this will be deleted
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Zimmer aufräumen", 1, false, Person().setPersonModel("Moritz Platen"), Categories.tasks, "07/02/2022"));
          Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Gurken holen", 1, false, Person(), Categories.shopping, "07/02/2022"));
          //#######################

          //Show Dialog to add items
          showDialog(
              context: context,
              builder: (builder) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => MenuService(),
                    ),
                  ],
                  child: const PoamPopUp(),
                );
              }
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
