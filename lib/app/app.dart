import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamList/PoamList.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: PoamList(),
    );
  }
}