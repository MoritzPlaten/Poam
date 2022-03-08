import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamFloatingButton/PoamFloatingButton.dart';
import 'package:poam/widgets/PoamList/PoamList.dart';
import 'package:provider/provider.dart';
import '../services/dateServices/Objects/Frequency.dart';
import '../services/itemServices/ItemModel.dart';
import '../services/itemServices/Objects/Category.dart';
import '../services/itemServices/Objects/Person.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  late Size size;
  late double padding;

  @override
  Widget build(BuildContext context) {

    ///Initialize
    size = MediaQuery.of(context).size;
    padding = MediaQuery.of(context).padding.top;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemModel("", 0, false, Person(""), Categories.tasks, "0xFFFFFF", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", false),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: padding),
          child: SizedBox(
            height: size.height,
            child: const PoamList(),
          ),
        ),
        floatingActionButton: const PoamFloatingButton(),
      ),
    );

  }
}
