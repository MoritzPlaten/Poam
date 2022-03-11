import 'package:flutter/material.dart';
import 'package:poam/services/localeService/Locales.dart';
import 'package:poam/widgets/PoamFloatingButton/PoamFloatingButton.dart';
import 'package:poam/widgets/PoamList/PoamList.dart';
import 'package:poam/widgets/PoamOptions/PoamOptions.dart';
import 'package:provider/provider.dart';
import '../services/dateServices/Objects/Frequency.dart';
import '../services/itemServices/ItemModel.dart';
import '../services/itemServices/Objects/Category.dart';
import '../services/itemServices/Objects/Person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  late Size size;
  late double padding;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    ///Initialize
    size = MediaQuery.of(context).size;
    padding = MediaQuery.of(context).padding.top;

    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemModel("", 0, false, Person(""), Categories.tasks, "0xFFFFFF", DateTime(0), DateTime(0), DateTime(0), DateTime(0), Frequency.single, "", false),
        ),
        ChangeNotifierProvider(
            create: (_) => Locales(""),
        ),
      ],
      child: Scaffold(
        body: selectedIndex == 0 ? Padding(
          padding: EdgeInsets.only(top: padding),
          child: SizedBox(
            height: size.height,
            child: const PoamList(),
          ),
        ) : PoamOptions(),
        floatingActionButton: selectedIndex == 0 ? const PoamFloatingButton() : null,
        bottomNavigationBar: BottomNavigationBar(
          items: [

            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_month),
              label: AppLocalizations.of(context)!.home,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );

  }
}
