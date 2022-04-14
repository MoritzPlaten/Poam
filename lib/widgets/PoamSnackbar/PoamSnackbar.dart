import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamSnackbar {

  void showSnackBar(BuildContext context, String text, Color color) {

    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(
            fontFamily: "Mona",
            fontSize: 12.5
        ),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}