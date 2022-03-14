import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poam/pages/app.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Database.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:poam/services/localeService/Locales.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  ///Register the adapters
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(FrequencyAdapter());
  Hive.registerAdapter(LocalesAdapter());
  Hive.registerAdapter(ChartServiceAdapter());

  ///Open our Box(DB)
  await Hive.openBox<ItemModel>(Database.Name);
  await Hive.openBox<Person>(Database.PersonName);
  await Hive.openBox<Locales>(Database.LocaleName);
  await Hive.openBox<ChartService>(Database.ChartName);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Locales(""),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  Locale _locale = Locale("en", "");

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    ///watcher
    context.watch<Locales>().getLocale();

    if (Provider.of<Locales>(context, listen: false).locales.length != 0) {
      setLocale(languageToLocale(context, Provider.of<Locales>(context, listen: false).locales.first.locale));
    }

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Poam',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const App(),
        '/listpage': (context) => const ListPage(),
      },
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
