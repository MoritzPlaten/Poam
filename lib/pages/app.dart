import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/widgets/PoamList/PoamList.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  late MenuService menuService;

  @override
  Widget build(BuildContext context) {

    //initialize
    menuService = MenuService();

    return Scaffold(
      body: const PoamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            //Add Items to the List
            Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel("Mama Wie geht es", 1, true, Categories.tasks, "07/02/2022"));
          })
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
