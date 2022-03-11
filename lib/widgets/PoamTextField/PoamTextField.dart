import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamTextField extends StatefulWidget {

  final String? label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PoamTextField({Key? key, this.label, this.keyboardType, this.maxLines, this.maxLength, this.validator, this.controller }) : super(key: key);

  @override
  _PoamTextFieldState createState() => _PoamTextFieldState();
}

class _PoamTextFieldState extends State<PoamTextField> {

  late Color primaryColor;

  @override
  Widget build(BuildContext context) {

    primaryColor = Theme.of(context).primaryColor;

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [

          TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            style: GoogleFonts.kreon(),
            validator: widget.validator,
            decoration: InputDecoration(
              labelText: widget.label,
              contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
              border: InputBorder.none,
            ),
          ),

          ///TODO: Recognize voice to write text
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {

                },
                icon: Icon(
                  Icons.mic,
                  color: primaryColor,
                ),
            ),
          ),

        ],
      )
    );
  }
}
