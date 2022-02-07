import 'package:flutter/material.dart';
import 'package:poam/pages/app.dart';
import 'package:poam/services/itemServices/MenuService.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Poam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MenuService(),
          ),
        ],
        child: const App(),
      ),
    );
  }
}