import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamDropDown extends StatefulWidget {

  final String? dropdownValue;
  final Function(String?)? onChanged;
  final Color? color;
  final Color? foregroundColor;
  final List<String>? items;
  final IconData? iconData;

  const PoamDropDown({Key? key, this.dropdownValue, this.onChanged, this.color, this.foregroundColor, this.items, this.iconData }) : super(key: key);

  @override
  _PoamDropDownState createState() => _PoamDropDownState();
}

class _PoamDropDownState extends State<PoamDropDown> {

  String activeValue = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      color: widget.color!,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton<String>(
          onChanged: widget.onChanged,
          value: widget.dropdownValue,

          // Hide the default underline
          underline: Container(),
          isExpanded: true,

          /// Gets all Items from a List<String>
          items: widget.items!.map((e) =>
              DropdownMenuItem<String>(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e,
                    style: GoogleFonts.novaMono(
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                value: e,
              )
          ).toList(),

          // Customize the selected item
          selectedItemBuilder: (BuildContext context) => widget.items!.map((e) =>
              Center(
                child: Text(
                  e,
                  style: GoogleFonts.novaMono(
                      fontSize: 14,
                      color: widget.foregroundColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
          ).toList(),

          icon: Icon(widget.iconData, color: widget.foregroundColor,),
        ),
      )
    );
  }
}
