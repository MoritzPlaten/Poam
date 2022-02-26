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

import '../../PoamDatePicker/PoamDatePicker.dart';

class PoamEditPop extends StatefulWidget {
  const PoamEditPop({Key? key}) : super(key: key);

  @override
  _PoamEditPopState createState() => _PoamEditPopState();
}

class _PoamEditPopState extends State<PoamEditPop> {

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


              Positioned(

                  bottom: 50,
                  right: size.width - (size.width / 2) - 50,

                  child: Center(
                    child: Row(
                      children: [

                        ///The close button
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 25,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)],
                              ),
                            ),
                          ),
                          onTap: () => {
                            setState(() {
                              Navigator.pop(context);
                            })
                          },
                        ),

                        const SizedBox(width: 20,),

                        ///The check button
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 25,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)],
                              ),
                            ),
                          ),
                          onTap: () => {
                            setState(() {
                              ///Add Item
                              if (_formKey.currentState!.validate()) {
                                bool isProblem = false;

                                ///if select Category task, then you can add only tasks for the future
                                if (categoryDropDownValue ==
                                    displayTextCategory(Categories.tasks) &&
                                    _dateController.text != "" &&
                                    _timeController.text != "" ?
                                DateTime(int.parse(_dateController.text
                                    .split("/")
                                    .last),
                                    int.parse(_dateController.text
                                        .split("/")
                                        .first),
                                    int.parse(
                                        _dateController.text.split("/").elementAt(
                                            1)),
                                    int.parse(_timeController.text
                                        .split(":")
                                        .first),
                                    int.parse(_timeController.text
                                        .split(":")
                                        .last), DateTime
                                        .now()
                                        .second).compareTo(
                                    DateTime.now()) /*>=*/ < 0 : false) {
                                  poamSnackbar.showSnackBar(context,
                                      "Sie können keine Aufgaben erstellen in der Vergangenheit!",
                                      primaryColor);
                                  isProblem = true;
                                }

                                RegExp regExp = new RegExp(r'^[0-9]+$');
                                if (categoryDropDownValue ==
                                    displayTextCategory(Categories.shopping) &&
                                    regExp.hasMatch(numberValue) == false) {
                                  poamSnackbar.showSnackBar(context,
                                      "Geben Sie eine Zahl ein, keine Buchstaben!",
                                      primaryColor);
                                  isProblem = true;
                                }

                                ///If there are no problems then add ItemModel
                                if (isProblem == false) {
                                  Provider.of<ItemModel>(context, listen: false)
                                      .addItem(ItemModel(

                                    ///Set Title
                                      titleValue,

                                      ///Set the number. if number == "", then set number to 0
                                      categoryDropDownValue ==
                                          displayTextCategory(Categories.shopping)
                                          ? int.parse(numberValue)
                                          : 0,

                                      ///isChecked == false
                                      false,

                                      ///Person
                                      Person(personValue),

                                      ///Set Category
                                      categoryDropDownValue == "Aufgabenliste"
                                          ? Categories.tasks
                                          : Categories.shopping,

                                      ///Set Color
                                      selectedColor.value.toRadixString(16),

                                      ///Set Time
                                      DateTime(0, 0, 0,
                                          categoryDropDownValue ==
                                              displayTextCategory(
                                                  Categories.tasks) &&
                                              _timeController.text != "" ?
                                          int.parse(_timeController.text
                                              .split(":")
                                              .first)
                                              :
                                          DateTime
                                              .now()
                                              .hour,
                                          categoryDropDownValue ==
                                              displayTextCategory(
                                                  Categories.tasks) &&
                                              _timeController.text != "" ?
                                          int.parse(_timeController.text
                                              .split(":")
                                              .last)
                                              :
                                          DateTime
                                              .now()
                                              .minute + 1),

                                      ///Set Date
                                      categoryDropDownValue ==
                                          displayTextCategory(Categories.tasks) &&
                                          _dateController.text != "" ?
                                      DateTime(
                                          int.parse(_dateController.text
                                              .split("/")
                                              .last),
                                          int.parse(_dateController.text
                                              .split("/")
                                              .first),
                                          int.parse(
                                              _dateController.text.split("/")
                                                  .elementAt(1)))
                                          : DateTime.now(),

                                      ///Set Frequency
                                      getFrequency(frequencyDropDownValue),
                                      ///Description
                                      descriptionValue
                                  )
                                  );

                                  Navigator.pop(context);
                                }
                              }
                            })
                          },
                        ),
                      ],
                    ),
                  )
              ),

            ],
          ),
        )
    );
  }
}
