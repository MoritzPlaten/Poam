import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamTextField extends StatefulWidget {

  final String? label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PoamTextField({Key? key, this.label, this.keyboardType, this.maxLines, this.validator, this.controller }) : super(key: key);

  @override
  _PoamTextFieldState createState() => _PoamTextFieldState();
}

class _PoamTextFieldState extends State<PoamTextField> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
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
