import 'package:flutter/material.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String frequencyDropDownValue = "";
  String categoryDropDownValue = "";
  String personDropDownValue = "";

  String dateExample = "";

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

    if (categoryDropDownValue == "") categoryDropDownValue = displayTextCategory(context, Categories.values.first);
    if (frequencyDropDownValue == "") frequencyDropDownValue = displayFrequency(context, Frequency.values.first);

    return ValueListenableBuilder(
        valueListenable: Hive.box<Person>(Database.PersonName).listenable(),
        builder: (context, Box<Person> box, widget) {

          List<Person> persons = box.values.toList();
          List<String> personNames = List.generate(persons.length, (index) => "");

          int i = 0;
          ///Add person names to list
          persons.forEach((element) {
            personNames[i] = element.name!;
            i++;
          });

          ///if no person is selected, then choose the first one of the list
          if (personDropDownValue == "" && personNames.length != 0) {
            personDropDownValue = personNames.first;
          }

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
                          items: displayAllCategories(context),
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
                          label: AppLocalizations.of(context)!.titleField,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 40,
                        ),

                        const SizedBox(height: 10,),

                        if (categoryDropDownValue == displayTextCategory(context, Categories.shopping))
                          PoamTextField(
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte geben Sie die Anzahl an!';
                              }
                              return value;
                            }),
                            controller: _numberController,
                            label: AppLocalizations.of(context)!.numberField,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            maxLength: 5,
                          ),

                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                          PoamPersonPicker(
                            personNames: personNames,
                            pickedPerson: personDropDownValue,
                            onChange: (value) {
                              setState(() {
                                personDropDownValue = value!;
                              });
                            },
                            box: box,
                          ),

                        ///TODO: Wenn der erste ausgewählt wird, also das Datum dann soll im zweiten Datum, das Datum von dem ersten eingesetzt werden, darf aber auch daraufhin geändert werden
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [

                              if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                                PoamDatePicker(
                                  title: AppLocalizations.of(context)!.dateFrom + ": ",
                                  dateController: _fromDateController,
                                  timeController: _fromTimeController,
                                ),

                              if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                                PoamDatePicker(
                                  title: AppLocalizations.of(context)!.dateTo + ": ",
                                  dateController: _toDateController,
                                  timeController: _toTimeController,
                                ),

                            ],
                          ),
                        ),

                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                          PoamDropDown(
                            dropdownValue: frequencyDropDownValue,
                            onChanged: (value) {
                              setState(() {
                                frequencyDropDownValue = value!;
                              });
                            },
                            items: displayAllFrequency(context),
                            color: Colors.white,
                            iconData: Icons.arrow_drop_down,
                            foregroundColor: Colors.black,
                          ),

                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
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
                          label: AppLocalizations.of(context)!.descriptionField,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          maxLength: 100,
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