import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';

import '../PoamDropDown/PoamDropDown.dart';

class PoamPersonPicker extends StatefulWidget {

  final List<String>? personNames;
  final String? pickedPerson;
  final Function(String?)? onChange;

  const PoamPersonPicker({ Key? key, this.personNames, this.pickedPerson, this.onChange }) : super(key: key);

  @override
  _PoamPersonPickerState createState() => _PoamPersonPickerState();
}

class _PoamPersonPickerState extends State<PoamPersonPicker> {

  late Size size;
  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  TextEditingController personController = TextEditingController();

  @override
  Row build(BuildContext context) {

    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    poamSnackbar = PoamSnackbar();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(
          width: size.width - size.width / 3,
          height: 55,

          child: PoamDropDown(
            dropdownValue: widget.pickedPerson == "" && widget.personNames!.length != 0 ? widget.personNames!.first : widget.pickedPerson,
            onChanged: widget.onChange,
            items: widget.personNames,
            color: Colors.white,
            iconData: Icons.arrow_drop_down,
            foregroundColor: Colors.black,
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
                        title: Text('Person'),
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
                            onPressed: () async {
                              Person person = Provider.of<Person>(context, listen: false);
                              bool s = await person.isExists(new Person(personController.text));

                              setState(() {
                                bool isProblem = false;

                                if (s == true) {
                                  poamSnackbar.showSnackBar(context,
                                      "Diese Person existiert bereits!",
                                      primaryColor);
                                  isProblem = true;
                                }

                                if (isProblem == false) {

                                  person.addPerson(new Person(personController.text));
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Text('Add'),
                          ),

                          ///TODO: Person Remove: doesn't work
                          TextButton(
                            onPressed: () async {
                              Person person = Provider.of<Person>(context, listen: false);
                              int index = person.PersonList.indexOf(new Person(personController.text));

                              print(personController.text);
                              setState(() {
                                person.removePerson(index);
                                Navigator.pop(context);
                              });
                            },
                            child: Text('Remove'),
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
