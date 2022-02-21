import 'dart:async';

import 'package:flutter/material.dart';

class PoamTextField extends StatefulWidget {

  final String? label;
  final TextEditingController? controllerCallback;

  const PoamTextField({Key? key, this.label, this.controllerCallback }) : super(key: key);

  @override
  _PoamTextFieldState createState() => _PoamTextFieldState();
}

class _PoamTextFieldState extends State<PoamTextField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextField(
        controller: widget.controllerCallback,
        decoration: InputDecoration(
            labelText: widget.label,
            contentPadding: EdgeInsets.all(10)
        ),
      ),
    );
  }
}
