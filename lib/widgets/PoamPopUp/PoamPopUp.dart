import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
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

  final ItemModel? itemModel;
  final bool? isEditMode;

  const PoamPopUp({ Key? key, this.itemModel, this.isEditMode }) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;
  late List<ItemModel> itemModel;

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
    itemModel = Provider.of<ItemModel>(context, listen: false).itemModelList;

    switch(widget.isEditMode) {

      ///Set Values of the itemModel in the Textformfields
      case true:

        if (personDropDownValue == "" && categoryDropDownValue == "" && frequencyDropDownValue == "") {
          frequencyDropDownValue = displayFrequency(context, widget.itemModel!.frequency);
          categoryDropDownValue = displayTextCategory(context, widget.itemModel!.categories);
          personDropDownValue = widget.itemModel!.person.name!;
          _titleController.text = widget.itemModel!.title;
          _numberController.text = widget.itemModel!.count.toString();
          _descriptionController.text = widget.itemModel!.description;
          _fromDateController.text = DateFormat.yMd().format(widget.itemModel!.fromDate);
          _toDateController.text = DateFormat.yMd().format(widget.itemModel!.toDate);
          _fromTimeController.text = widget.itemModel!.fromTime.hour.toString() + " : " + widget.itemModel!.fromTime.minute.toString();
          _toTimeController.text = widget.itemModel!.toTime.hour.toString() + " : " + widget.itemModel!.toTime.minute.toString();
          selectedColor = Color(HexColor(widget.itemModel!.hex).value);
        }
        break;

        ///EditMode is false
      case false:
        if (categoryDropDownValue == "") categoryDropDownValue = displayTextCategory(context, Categories.values.first);
        if (frequencyDropDownValue == "") frequencyDropDownValue = displayFrequency(context, Frequency.values.first);
        break;

        ///Error
      default:
        print("Error");
        break;
    }

    return ValueListenableBuilder(
        valueListenable: Hive.box<Person>(Database.PersonName).listenable(),
        builder: (context, Box<Person> box, widgets) {

          ///Get All persons
          List<Person> persons = box.values.toList();
          List<String> personNames = getPersonsAsStrings(persons);

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

                        ///Displays the Category DropDownMenu
                        PoamDropDown(
                          dropdownValue: categoryDropDownValue,
                          onChanged: (value) {
                            categoryDropDownValue = value!;
                          },
                          ///if EditMode is true then only display the Category of the ItemModel
                          items: widget.isEditMode == false ? displayAllCategories(context) : List.generate(1, (index) => displayTextCategory(context, widget.itemModel!.categories)),
                          color: primaryColor,
                          iconData: Icons.arrow_drop_down,
                          foregroundColor: Colors.white,
                        ),

                        const SizedBox(height: 10,),

                        ///Displays the title
                        PoamTextField(
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.messageWriteTitle;
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

                        ///Displays the Number field
                        if (categoryDropDownValue == displayTextCategory(context, Categories.shopping))
                          PoamTextField(
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.messageWriteNumber;
                              }
                              return null;
                            }),
                            controller: _numberController,
                            label: AppLocalizations.of(context)!.numberField,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            maxLength: 5,
                          ),

                        ///Displays the PersonPicker
                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                          PoamPersonPicker(
                            personNames: personNames,
                            pickedPerson: personDropDownValue,
                            onChange: (value) {
                              personDropDownValue = value!;
                            },
                            box: box,
                          ),

                        ///TODO: if the first date is selected, then set the second date equals the first date
                        ///Displays the Date-Time-Picker
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

                        ///Displays the Frequency DropDownMenu
                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                          PoamDropDown(
                            dropdownValue: frequencyDropDownValue,
                            onChanged: (value) {
                              frequencyDropDownValue = value!;
                            },
                            items: displayAllFrequency(context),
                            color: Colors.white,
                            iconData: Icons.arrow_drop_down,
                            foregroundColor: Colors.black,
                          ),

                        ///Displays the Color Picker
                        if (categoryDropDownValue == displayTextCategory(context, Categories.tasks))
                          PoamColorPicker(
                            pickedColor: selectedColor,
                            onChangeColor: (Color? color){ //on color picked
                              selectedColor = color!;
                            },
                          ),

                        ///Displays the Desciption field
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

                  ///Displays the PoamPopMenu
                  PoamPopMenu(
                    formKey: _formKey,
                    isEditMode: widget.isEditMode,
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
                    ///if EditMode is true then get the index of this itemModel, else set the itemIndex to 0
                    itemIndex: widget.isEditMode == true ? itemModel.indexOf(widget.itemModel!) : 0,
                  ),

                ],
              ),
            ),
          );
        }
      );
  }
}