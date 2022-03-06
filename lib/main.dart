import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poam/pages/app.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Database.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  ///Register the adapters
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(FrequencyAdapter());

  ///initialize DateFormat
  //await initializeDateFormatting();

  ///Open our Box(DB)
  await Hive.openBox<ItemModel>(Database.Name);
  await Hive.openBox<Person>(Database.PersonName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///### MAIN APP ####

    ///TODO: Add Options
    ///TODO: Change Language in options

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Poam',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const App(),
        '/listpage': (context) => ListPage(),
      },
      locale: Locale("de", ""),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}