import 'package:flutter/material.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/colorServices/ColorService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Alarms/Alarms.dart';
import 'package:poam/services/itemServices/Objects/Amounts/Amounts.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:poam/widgets/PoamPopUp/PoamPopUp.dart';
import 'package:provider/provider.dart';

import '../../services/itemServices/Objects/Amounts/QuantityType.dart';

class PoamFloatingButton extends StatelessWidget {

  final Categories? categories;

  const PoamFloatingButton({ Key? key, this.categories }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///initialize
    Color primaryColor = Theme.of(context).primaryColor;
    ColorService colorService = ColorService();

    Color newColor = colorService.createColor(primaryColor);

    void addItemModel() {

      ///Navigate to PoamPopUp and add a Provider
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) =>
                    ItemModel(
                        "",
                        Amounts(0, QuantityType.Pieces),
                        false,
                        Person(""),
                        Categories.tasks,
                        "0xFFFFFF",
                        DateTime(0),
                        DateTime(0),
                        DateTime(0),
                        DateTime(0),
                        Frequency.single,
                        "",
                        Alarms([]),
                        false,
                        false
                    ),
              ),
              ChangeNotifierProvider(
                create: (_) => ChartService(0, 0, DateTime(0)),
              ),
              ChangeNotifierProvider(
                create: (_) => Person(""),
              ),
            ],
            child: PoamPopUp(
              isEditMode: false,
              categories: this.categories,
            ),
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: () => addItemModel(),
      child: Container(
        width: 60,
        height: 60,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
              radius: 0.9,
              center: const Alignment(0.7, -0.6),
              colors: [primaryColor, newColor],
              stops: const [0.1, 0.8]),
        ),
      ),
    );
  }
}

