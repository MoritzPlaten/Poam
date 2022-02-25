import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamTextField extends StatefulWidget {

  final String? label;
  final String? Function(String?)? validator;

  const PoamTextField({Key? key, this.label, this.validator }) : super(key: key);

  @override
  _PoamTextFieldState createState() => _PoamTextFieldState();
}

class _PoamTextFieldState extends State<PoamTextField> {

  ///TODO: Fix the Error message

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextFormField(
        style: GoogleFonts.kreon(),
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
