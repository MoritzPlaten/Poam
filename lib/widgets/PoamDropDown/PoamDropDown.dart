import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoamDropDown extends StatefulWidget {

  final String? dropdownValue;
  final Function(String?)? onChanged;
  final Color? color;
  final List<String>? items;
  final IconData? iconData;

  const PoamDropDown({Key? key, this.dropdownValue, this.onChanged, this.color, this.items, this.iconData }) : super(key: key);

  @override
  _PoamDropDownState createState() => _PoamDropDownState();
}

class _PoamDropDownState extends State<PoamDropDown> {

  String activeValue = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.color!.withGreen(140),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        onChanged: widget.onChanged,
        value: widget.dropdownValue,

        // Hide the default underline
        underline: Container(),
        isExpanded: true,

        /// Gets all Items from a List<String>
        items: widget.items!.map((e) => DropdownMenuItem(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              e,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          value: e,
        )).toList(),

        // Customize the selected item
        selectedItemBuilder: (BuildContext context) => widget.items!.map((e) => Center(
          child: Text(
            e,
            style: GoogleFonts.kreon(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400
            ),
          ),
        )).toList(),

        icon: Icon(widget.iconData, color: Colors.white,),
      ),
    );
  }
}
