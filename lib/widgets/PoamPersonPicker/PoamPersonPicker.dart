import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';

import '../PoamDropDown/PoamDropDown.dart';

class PoamPersonPicker extends StatefulWidget {

  final List<String>? personNames;

  const PoamPersonPicker({ Key? key, this.personNames }) : super(key: key);

  @override
  _PoamPersonPickerState createState() => _PoamPersonPickerState();
}

class _PoamPersonPickerState extends State<PoamPersonPicker> {

  late Size size;
  late Color primaryColor;
  TextEditingController personController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(
          width: size.width - size.width / 3.5,
          height: 55,

          child: PoamDropDown(
            dropdownValue: widget.personNames!.length != 0 ? widget.personNames!.first : "Personen",
            onChanged: (value) {
              setState(() {
                //categoryDropDownValue = value!;
              });
            },
            items: widget.personNames,
            color: primaryColor,
            iconData: Icons.arrow_drop_down,
            foregroundColor: Colors.white,
          ),
        ),

        IconButton(
          onPressed: () {
            setState(() {

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => Person(""),
                      ),
                    ],
                    builder: (context, widget) {
                      return AlertDialog(
                          title: Text('Add Person'),
                          content: PoamTextField(
                          label: "Name",
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          validator: ((value) {
                            return null;
                          }),
                          controller: personController,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<Person>(context, listen: false).addPerson(new Person(personController.text));
                                Navigator.pop(context);
                              });
                            },
                            child: Text('Add'),
                          ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text('Cancel'),
                        ),
                        ],
                      );
                    },
                  );
                },
              );
            });
          },
          icon: const Icon(Icons.add_outlined),
        ),

      ],
    );
  }
}
