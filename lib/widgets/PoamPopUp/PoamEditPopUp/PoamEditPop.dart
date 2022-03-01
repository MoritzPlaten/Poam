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
import '../PoamPopMenu/PoamPopMenu.dart';

class PoamEditPop extends StatefulWidget {
  const PoamEditPop({Key? key}) : super(key: key);

  @override
  _PoamEditPopState createState() => _PoamEditPopState();
}

class _PoamEditPopState extends State<PoamEditPop> {

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
        body: SizedBox(
          height: size.height,
          child:

          ///The Form
          Form(
            key: _formKey,
            child: Stack(

              children: [

                ListView(
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

                PoamPopMenu(
                  formKey: _formKey,
                  categoryDropDownValue: categoryDropDownValue,
                  numberController: _numberController,
                  titleController: _titleController,
                  personValue: "",
                  selectedColor: selectedColor,
                  frequencyDropDownValue: frequencyDropDownValue,
                  descriptionController: _descriptionController,
                  fromDateController: _fromDateController,
                  fromTimeController: _fromTimeController,
                ),

              ],
            ),
          ),
        )
    );
  }
}
