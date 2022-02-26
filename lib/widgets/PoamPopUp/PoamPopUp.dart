import 'package:flutter/material.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamColorPicker/PoamColorPicker.dart';
import 'package:poam/widgets/PoamDropDown/PoamDropDown.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';

import '../PoamDatePicker/PoamDatePicker.dart';
import 'PoamPopMenu/PoamPopMenu.dart';

class PoamPopUp extends StatefulWidget {

  const PoamPopUp({Key? key}) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;
  String categoryDropDownValue = displayTextCategory(Categories.values.first);
  ///TODO: Frequency is not working
  String frequencyDropDownValue = displayFrequency(Frequency.values.first);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  ///TODO: Add DatePicker "Bis" to the ItemModel, ...
  TextEditingController _date2Controller = TextEditingController();
  TextEditingController _time2Controller = TextEditingController();
  Color selectedColor = Colors.blueAccent;

  String titleValue = "", numberValue = "", personValue = "", descriptionValue = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    ///Refresh Items
    context.watch<ItemModel>().getItems();
    context.watch<Person>().getPersons();

    ///initialize
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    poamSnackbar = PoamSnackbar();

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(

          children: [

            ///TODO: Sort Time
            ///The Form
            Form(
              key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(top: 60, right: 30, left: 30, bottom: 10),
                  shrinkWrap: true,
                  children: [

                    PoamDropDown(
                      dropdownValue: categoryDropDownValue,
                      onChanged: (value) {
                        setState(() {
                          categoryDropDownValue = value!;
                        });
                      },
                      items: displayAllCategories(),
                      color: primaryColor,
                      iconData: Icons.arrow_drop_down,
                      foregroundColor: Colors.white,
                    ),

                    const SizedBox(height: 10,),

                    PoamTextField(
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie den Titel an!';
                        }
                        titleValue = value;
                        return null;
                      }),
                      label: "Titel",
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10,),

                    if (categoryDropDownValue == displayTextCategory(Categories.shopping))
                      PoamTextField(
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie die Anzahl an!';
                          }
                          numberValue = value;
                          return null;
                        }),
                        label: "Anzahl",
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                      ),

                    ///TODO: Set an DropDown, where the persons would be display => with an Add Person Button

                    /*ValueListenableBuilder(
                          valueListenable: Hive.box<Person>(Database.PersonName).listenable(),
                          builder: (context, Box box, widget) {

                            List<Person> persons = box.values.toList() as List<Person>;
                            List<String> personNames = List.generate(persons.length, (index) => "");

                            int i = 0;
                            persons.forEach((element) {
                              personNames[i] = element.name!;
                              i++;
                            });

                            return Row(
                              children: [

                                PoamDropDown(
                                dropdownValue: personNames.first,
                                  onChanged: (value) {
                                    setState(() {
                                      categoryDropDownValue = value!;
                                    });
                                  },
                                  items: personNames,
                                  color: primaryColor,
                                  iconData: Icons.arrow_drop_down,
                                  foregroundColor: Colors.white,
                                ),

                                IconButton(
                                  onPressed: () {

                                  },
                                  icon: Icon(Icons.add_outlined),
                                ),

                              ],
                            );
                          }
                    ),*/

                    if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                      PoamTextField(
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte geben Sie eine Person an!';
                          }
                          personValue = value;
                          return null;
                        }),
                        label: "Person",
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),

                    if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                      PoamDatePicker(
                        title: "Von: ",
                        dateController: _dateController,
                        timeController: _timeController,
                      ),

                    if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                      PoamDatePicker(
                        title: "Bis: ",
                        dateController: _date2Controller,
                        timeController: _time2Controller,
                      ),

                    if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                      PoamDropDown(
                        dropdownValue: frequencyDropDownValue,
                        onChanged: (value) {
                          setState(() {
                            frequencyDropDownValue = value!;
                          });
                        },
                        items: displayAllFrequency(),
                        color: Colors.white,
                        iconData: Icons.arrow_drop_down,
                        foregroundColor: Colors.black,
                      ),

                    if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                      PoamColorPicker(
                        pickedColor: selectedColor,
                        onChangeColor: (Color? color){ //on color picked
                          setState(() {
                            selectedColor = color!;
                          });
                        },
                      ),

                      PoamTextField(
                        validator: ((value) {
                          descriptionValue = value!;
                          return null;
                        }),
                        label: "Beschreibung",
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),

                  ],
                ),
            ),

            PoamPopMenu(
              formKey: _formKey,
              categoryDropDownValue: categoryDropDownValue,
              numberValue: numberValue,
              titleValue: titleValue,
              personValue: personValue,
              selectedColor: selectedColor,
              frequencyDropDownValue: frequencyDropDownValue,
              descriptionValue: descriptionValue,
              dateController: _dateController,
              timeController: _timeController,
            ),

          ],
        ),
      )
    );
  }
}
