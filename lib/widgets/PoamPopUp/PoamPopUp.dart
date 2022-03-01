import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamColorPicker/PoamColorPicker.dart';
import 'package:poam/widgets/PoamDropDown/PoamDropDown.dart';
import 'package:poam/widgets/PoamPersonPicker/PoamPersonPicker.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';

import '../../services/itemServices/Objects/Database.dart';
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

  ///TODO: Frequency is not working
  String frequencyDropDownValue = displayFrequency(Frequency.values.first);
  String categoryDropDownValue = displayTextCategory(Categories.values.first);
  String personDropDownValue = "";

  Color selectedColor = Colors.blueAccent;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ///Refresh Items
    context.watch<ItemModel>().getItems();
    context.watch<Person>().getPersons();

    ///initialize
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;
    poamSnackbar = PoamSnackbar();

    return ValueListenableBuilder(
        valueListenable: Hive.box<Person>(Database.PersonName).listenable(),
        builder: (context, Box<Person> box, widget) {

          List<Person> persons = box.values.toList();
          List<String> personNames = List.generate(persons.length, (index) => "");

          int i = 0;
          persons.forEach((element) {
            personNames[i] = element.name!;
            i++;
          });

          return Scaffold(
            body: Form(
              key: _formKey,
              child: Stack(

                children: [

                  SizedBox(

                    width: size.width,
                    height: size.height,

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
                            return null;
                          }),
                          controller: _titleController,
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
                              return null;
                            }),
                            controller: _numberController,
                            label: "Anzahl",
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                          ),

                        ///TODO: Set an DropDown, where the persons would be display => with an Add Person Button

                        if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                          PoamPersonPicker(
                            personNames: personNames,
                            pickedPerson: personDropDownValue,
                            onChange: (value) {
                              setState(() {
                                personDropDownValue = value!;
                              });
                            },
                          ),


                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [

                              if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                                PoamDatePicker(
                                  title: "Von: ",
                                  dateController: _fromDateController,
                                  timeController: _fromTimeController,
                                ),

                              if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                                PoamDatePicker(
                                  title: "Bis: ",
                                  dateController: _toDateController,
                                  timeController: _toTimeController,
                                ),

                            ],
                          ),
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
                            return null;
                          }),
                          controller: _descriptionController,
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
                    numberController: _numberController,
                    titleController: _titleController,
                    personValue: personDropDownValue,
                    selectedColor: selectedColor,
                    frequencyDropDownValue: frequencyDropDownValue,
                    descriptionController: _descriptionController,
                    fromDateController: _fromDateController,
                    fromTimeController: _fromTimeController,
                    toDateController: _toDateController,
                    toTimeController: _toTimeController,
                  ),

                ],
              ),
            ),
          );
        }
      );
  }
}

/*
class PoamPopUp extends StatefulWidget {

  const PoamPopUp({Key? key}) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;

  ///TODO: Frequency is not working
  String frequencyDropDownValue = displayFrequency(Frequency.values.first);
  String categoryDropDownValue = displayTextCategory(Categories.values.first);

  Color selectedColor = Colors.blueAccent;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _personController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
      body: Form(
              key: _formKey,
                child: Stack(

                    children: [

                      SizedBox(

                        width: size.width,
                        height: size.height,

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
                                return null;
                              }),
                              controller: _titleController,
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
                                  return null;
                                }),
                                controller: _numberController,
                                label: "Anzahl",
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),

                            ///TODO: Set an DropDown, where the persons would be display => with an Add Person Button

                            /*Container(
                              child: ValueListenableBuilder(
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
                                          dropdownValue: personNames.length != 0 ? personNames.first : "Person",
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
                              ),
                            ),*/

                            if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                              PoamTextField(
                                validator: ((value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bitte geben Sie eine Person an!';
                                  }
                                  return null;
                                }),
                                label: "Person",
                                controller: _personController,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                              ),

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [

                                  if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                                    PoamDatePicker(
                                      title: "Von: ",
                                      dateController: _fromDateController,
                                      timeController: _fromTimeController,
                                    ),

                                  if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                                    PoamDatePicker(
                                      title: "Bis: ",
                                      dateController: _toDateController,
                                      timeController: _toTimeController,
                                    ),

                                ],
                              ),
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
                                return null;
                              }),
                              controller: _descriptionController,
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
                        numberController: _numberController,
                        titleController: _titleController,
                        personController: _personController,
                        selectedColor: selectedColor,
                        frequencyDropDownValue: frequencyDropDownValue,
                        descriptionController: _descriptionController,
                        fromDateController: _fromDateController,
                        fromTimeController: _fromTimeController,
                        toDateController: _toDateController,
                        toTimeController: _toTimeController,
                      ),

                    ],
                ),
            ),

    );
  }
} */