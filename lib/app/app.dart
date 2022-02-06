import 'package:flutter/material.dart';
import 'package:poam/widgets/PoamList/PoamList.dart';
import 'package:poam/widgets/PoamNavigationBar/PoamNavigationBar.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poam', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
      ),
      body: PoamList(),
      //bottomNavigationBar: PoamNavigationBar(),
    );
  }
}