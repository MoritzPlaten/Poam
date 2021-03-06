import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:poam/pages/app.dart';
import 'package:poam/pages/listpage.dart';
import 'package:poam/services/chartServices/ChartService.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Alarms/Alarms.dart';
import 'package:poam/services/itemServices/Objects/Amounts/Amounts.dart';
import 'package:poam/services/itemServices/Objects/Amounts/QuantityType.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Database.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:poam/services/keyServices/KeyService.dart';
import 'package:poam/services/localeService/Locales.dart';
import 'package:poam/services/localeService/Objects/Languages.dart';
import 'package:poam/services/notificationServices/NotificationService.dart';
import 'package:poam/services/settingService/Settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;
import 'package:flutter_background/flutter_background.dart';


///TODO: Widget erstellen für den Startbildschirm

///https://docs.flutter.dev/perf/rendering/shader
///flutter run --profile --cache-sksl
///flutter build apk --bundle-sksl-path flutter_01.sksl.json
///flutter build ios --bundle-sksl-path flutter_01.sksl.json

Future<List<int>> getItemModelKey() async {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.ItemModelKey);
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: KeyService.ItemModelKey, value: base64UrlEncode(key));
  }

  String? read = await secureStorage.read(key: KeyService.ItemModelKey);

  var encryptionKey = base64Url.decode(read!);
  return encryptionKey;
}

Future<List<int>> getPersonKey() async {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.PersonKey);
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: KeyService.PersonKey, value: base64UrlEncode(key));
  }

  String? read = await secureStorage.read(key: KeyService.PersonKey);

  var encryptionKey = base64Url.decode(read!);
  return encryptionKey;
}

Future<List<int>> getChartServiceKey() async {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.ChartServiceKey);
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: KeyService.ChartServiceKey, value: base64UrlEncode(key));
  }

  String? read = await secureStorage.read(key: KeyService.ChartServiceKey);

  var encryptionKey = base64Url.decode(read!);
  return encryptionKey;
}

Future<List<int>> getSettingsKey() async {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.SettingsKey);
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: KeyService.SettingsKey, value: base64UrlEncode(key));
  }

  String? read = await secureStorage.read(key: KeyService.SettingsKey);

  var encryptionKey = base64Url.decode(read!);
  return encryptionKey;
}

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
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(AmountsAdapter());
  Hive.registerAdapter(QuantityTypeAdapter());
  Hive.registerAdapter(AlarmsAdapter());

  ///Open our Box(DB)
  var itemModelKey = await getItemModelKey();
  await Hive.openBox<ItemModel>(Database.Name, encryptionCipher: HiveAesCipher(itemModelKey));

  var personKey = await getPersonKey();
  await Hive.openBox<Person>(Database.PersonName, encryptionCipher: HiveAesCipher(personKey));

  await Hive.openBox<Locales>(Database.LocaleName);

  var chartServiceKey = await getChartServiceKey();
  await Hive.openBox<ChartService>(Database.ChartName, encryptionCipher: HiveAesCipher(chartServiceKey));

  var settingsKey = await getSettingsKey();
  await Hive.openBox<Settings>(Database.SettingsName, encryptionCipher: HiveAesCipher(settingsKey));

  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Poam",
    notificationText: "Background System",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );

  bool backgroundInitializeSuccess = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (!backgroundInitializeSuccess) {
    print("Initialize go wrong");
  }

  bool enableBackgroundSuccess = await FlutterBackground.enableBackgroundExecution();
  if (!enableBackgroundSuccess) {
    print("Enable Background go wrong");
  }

  NotificationService notificationService = NotificationService();
  notificationService.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Locales(""),
      ),
      ChangeNotifierProvider(
        create: (_) => Settings(0),
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
  Color _menuColor = Colors.blueAccent;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  void setMenuColor(Color value) {
    setState(() {
      _menuColor = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    ///watcher
    context.watch<Locales>().getLocale();
    context.watch<Settings>().getSettings();

    ///Set the values in the MaterialApp
    if (Provider.of<Locales>(context, listen: false).locales.length != 0) {
      setLocale(languageToLocale(context, Provider.of<Locales>(context, listen: false).locales.first.locale));
    }
    if (Provider.of<Settings>(context, listen: false).settings.length != 0) {
      setMenuColor(Color(Provider.of<Settings>(context, listen: false).settings.first.ColorHex));
    }

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Poam',
      ///TODO: add Dark Mode
      theme: ThemeData(
        primaryColor: _menuColor,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
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
