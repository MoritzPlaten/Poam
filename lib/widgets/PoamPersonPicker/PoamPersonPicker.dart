import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../PoamDropDown/PoamDropDown.dart';

class PoamPersonPicker extends StatefulWidget {
  final List<String>? personNames;
  final String? pickedPerson;
  final Function(String?)? onChange;
  final Box<Person>? box;

  const PoamPersonPicker(
      {Key? key, this.personNames, this.pickedPerson, this.onChange, this.box}) : super(key: key);

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

    ///watch
    context.watch<Person>().getPersons();

    ///initialize
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    poamSnackbar = PoamSnackbar();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width - size.width / 2,
          height: 55,
          child: PoamDropDown(
            dropdownValue:
            widget.personNames!.contains(widget.pickedPerson) == false || widget.pickedPerson == "" && widget.personNames!.length != 0 ?
                widget.personNames!.length != 0 ? widget.personNames!.first :  ""
                : widget.pickedPerson,
            onChanged: widget.onChange,
            items: widget.personNames,
            color: Colors.white,
            iconData: Icons.arrow_drop_down,
            foregroundColor: Colors.black,
          ),
        ),
        ///Add a Person
        IconButton(
          onPressed: () {

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.addPerson),
                    content: PoamTextField(
                      label: "Name",
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 30,
                      validator: ((value) {
                        return null;
                      }),
                      controller: personController,
                    ),
                    actions: [

                      TextButton(
                        onPressed: () async {
                          bool personExist = widget.box!.values.contains(new Person(personController.text));

                          bool isProblem = false;

                          if (personExist == true) {
                            poamSnackbar.showSnackBar(context,
                                AppLocalizations.of(context)!.messagePersonNotExists,
                                primaryColor);
                            isProblem = true;
                          }

                          if (isProblem == false) {

                            widget.box!.add(new Person(personController.text));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.addButton),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.exitButton),
                      ),
                    ],
                  );
                });

          },
          icon: const Icon(Icons.add_outlined),
        ),

        ///Remove the active Person
        IconButton(
            onPressed: () async {

              int i = -1, e = 0;
              int numberOfItems = widget.box!.values.where((element) => element.name == widget.pickedPerson!.trim()).length;
              
              if (numberOfItems != 0) {
                widget.box!.values.forEach((element) {
                  ++i;
                  if (element.name == widget.pickedPerson!.trim()) {
                    e = i;
                  }
                });
              }

              if (numberOfItems == 0) {
                poamSnackbar.showSnackBar(context,
                    "Diese Person existiert nicht!",
                    primaryColor);

              } else {
                widget.box!.deleteAt(e);
              }
            },
            icon: const Icon(Icons.remove),
        ),

      ],
    );
  }
}