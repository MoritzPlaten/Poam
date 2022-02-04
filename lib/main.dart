import 'package:flutter/material.dart';
import 'package:poam/app/app.dart';

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
      home: const App(),
    );
  }
}