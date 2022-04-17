import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/dateServices/Objects/Frequency.dart';
import 'package:poam/services/itemServices/Objects/Alarms/Alarms.dart';
import 'package:poam/services/itemServices/Objects/Amounts/Amounts.dart';
import 'package:poam/services/itemServices/Objects/Amounts/QuantityType.dart';
import 'package:poam/services/itemServices/Objects/Category/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person/Person.dart';
import 'package:poam/widgets/PoamColorPicker/PoamColorPicker.dart';
import 'package:poam/widgets/PoamDatePicker/PoamDateCheck/PoamDateCheck.dart';
import 'package:poam/widgets/PoamDropDown/PoamDropDown.dart';
import 'package:poam/widgets/PoamNotification/PoamNotification.dart';
import 'package:poam/widgets/PoamPersonPicker/PoamPersonPicker.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/chartServices/ChartService.dart';
import '../../services/itemServices/Objects/Database.dart';
import '../../services/settingService/Settings.dart';
import '../PoamDatePicker/PoamDatePicker.dart';
import 'PoamPopMenu/PoamPopMenu.dart';

class PoamPopUp extends StatefulWidget {
  final ItemModel? itemModel;
  final bool? isEditMode;

  const PoamPopUp({Key? key, this.itemModel, this.isEditMode})
      : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {
  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;
  late List<ItemModel> itemModel;

  String frequencyDropDownValue = "";
  String categoryDropDownValue = "";
  String personDropDownValue = "";
  String quantityTypeDropwDownValue = "";

  List<DateTime> alarms = List.generate(0, (index) => DateTime(0));
  Color? selectedColor;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool? _firstFromDatePicked;
  bool? _firstFromTimePicked;
  bool? _secondFromDatePicked;
  bool? _secondFromTimePicked;

  bool isDateChecked = false;

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

    return ValueListenableBuilder(
        valueListenable: Hive.box<Person>(Database.PersonName).listenable(),
        builder: (context, Box<Person> box, widgets) {

          ///Get All persons
          List<Person> persons = box.values.toList();
          List<String> personNames = getPersonsAsStrings(persons);

          switch (widget.isEditMode) {

          ///Set Values of the itemModel in the Textformfields
            case true:
            ///TODO: Daten sollen immer aktualisiert werden. Zum Beispiel: PoamPersonPicker remove Person => abhacken => Person wird immer noch angezeigt, soweit man nicht eine neue Person angetippt hat
              if (personDropDownValue == "" && categoryDropDownValue == "" && frequencyDropDownValue == "") {

                frequencyDropDownValue = displayFrequency(context, widget.itemModel!.frequency);
                categoryDropDownValue = displayTextCategory(context, widget.itemModel!.categories);
                personDropDownValue = widget.itemModel!.person.name!;
                _titleController.text = widget.itemModel!.title;
                _numberController.text = widget.itemModel!.amounts.Number.toString();
                quantityTypeDropwDownValue = displayTextQuantityType(context, widget.itemModel!.amounts.quantityType!);
                _descriptionController.text = widget.itemModel!.description;
                selectedColor = Color(HexColor(widget.itemModel!.hex).value);
                alarms = widget.itemModel!.alarms.listOfAlarms;
                isDateChecked = widget.itemModel!.AllowDate;

                ///DateTimes
                DateTime isFromDateTimeOver = DateTime(
                    widget.itemModel!.fromDate.year,
                    widget.itemModel!.fromDate.month,
                    widget.itemModel!.fromDate.day,
                    widget.itemModel!.fromTime.hour,
                    widget.itemModel!.fromTime.minute);
                DateTime isToDateTimeOver = DateTime(
                    widget.itemModel!.toDate.year,
                    widget.itemModel!.toDate.month,
                    widget.itemModel!.toDate.day,
                    widget.itemModel!.toTime.hour,
                    widget.itemModel!.toTime.minute);

                ///Durations
                Duration dateDuration = isToDateTimeOver.difference(isFromDateTimeOver);
                Duration timeDuration = widget.itemModel!.toTime.difference(widget.itemModel!.fromTime);

                ///if the From DateTime is not over, then set the item settings. Else set DateTime.now()
                if (isFromDateTimeOver.compareTo(DateTime.now()) > 0) {

                  _fromDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(isFromDateTimeOver);
                  _fromTimeController.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(isFromDateTimeOver);
                  _toDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(isToDateTimeOver);
                  _toTimeController.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(isToDateTimeOver);

                  ///if the to DateTime is not over and the fromDateTime is over, then set item settings
                } else if (isToDateTimeOver.compareTo(DateTime.now()) > 0 && isFromDateTimeOver.compareTo(DateTime.now()) < 0) {

                  _toDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.now().add(dateDuration)); //.add(dateDuration)
                  _toTimeController.text = DateTime.now().add(timeDuration).hour.toString() + ":" + (DateTime.now().add(timeDuration).minute + 1).toString();

                  ///if the to DateTime is not over, then set item settings
                } else if (isToDateTimeOver.compareTo(DateTime.now()) > 0) {

                  _toDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.itemModel!.fromDate.add(dateDuration)); //.add(dateDuration)
                  _toTimeController.text = widget.itemModel!.fromTime.add(timeDuration).hour.toString() + ":" + widget.itemModel!.fromTime.add(timeDuration).minute.toString();
                } else if (isFromDateTimeOver.compareTo(isToDateTimeOver) == 0) {

                  ///if the to DateTime is equal the from DateTime and is not over, then set item settings
                  if (isToDateTimeOver.compareTo(DateTime.now()) > 0) {

                    _toDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.itemModel!.toDate);
                    _toTimeController.text = widget.itemModel!.toTime.hour.toString() + ":" + widget.itemModel!.toTime.minute.toString();
                  }

                  ///if the toDateTime is over
                } else if (isToDateTimeOver.compareTo(DateTime.now()) < 0) {

                  _toDateController.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.now().add(dateDuration));
                  _toTimeController.text = DateTime.now().add(timeDuration).hour.toString() + ":" + (DateTime.now().add(timeDuration).minute + 1).toString();
                }
              }
              break;

          ///EditMode is false
            case false:

              if (categoryDropDownValue == "")
                categoryDropDownValue =
                    displayTextCategory(context, Categories.values.first);
              if (frequencyDropDownValue == "")
                frequencyDropDownValue =
                    displayFrequency(context, Frequency.values.first);
              if (quantityTypeDropwDownValue == "") {
                quantityTypeDropwDownValue = displayTextQuantityType(context, QuantityType.values.first);
              }
              ///Set selectedColor from db
              if (selectedColor == null) {
                selectedColor = Color(Provider.of<Settings>(context, listen: false).settings.first.ColorHex);
              }
              ///if no person is selected, then choose the first one of the list
              if (personDropDownValue == "" && personNames.length != 0) {
                personDropDownValue = personNames.first;
              }

              break;

          ///Error
            default:
              print("Error");
              break;
          }

          return Scaffold(
            body: Form(
              key: _formKey,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: ListView(
                      padding: const EdgeInsets.only(
                          top: 60, right: 30, left: 30, bottom: 10),
                      shrinkWrap: true,
                      children: [
                        ///Displays the Category DropDownMenu
                        PoamDropDown(
                          dropdownValue: categoryDropDownValue,
                          onChanged: (value) {
                            categoryDropDownValue = value!;
                          },

                          ///if EditMode is true then only display the Category of the ItemModel
                          items: widget.isEditMode == false
                              ? displayAllCategories(context)
                              : List.generate(
                                  1,
                                  (index) => displayTextCategory(
                                      context, widget.itemModel!.categories)),
                          color: primaryColor,
                          iconData: Icons.arrow_drop_down,
                          foregroundColor: Colors.white,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ///Displays the title
                        PoamTextField(
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .messageWriteTitle;
                            }
                            return null;
                          }),
                          controller: _titleController,
                          label: AppLocalizations.of(context)!.titleField,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 40,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ///Displays the Number field
                        if (categoryDropDownValue ==
                            displayTextCategory(context, Categories.shopping))
                          Row(
                            children: [

                              Flexible(
                                flex: 2,
                                child: PoamTextField(
                                  validator: ((value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .messageWriteNumber;
                                    }
                                    return null;
                                  }),
                                  controller: _numberController,
                                  label: AppLocalizations.of(context)!.numberField,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  maxLength: 5,
                                ),
                              ),

                              Flexible(
                                flex: 1,
                                child: PoamDropDown(
                                  dropdownValue: quantityTypeDropwDownValue,
                                  onChanged: (value) {
                                    quantityTypeDropwDownValue = value!;
                                  },
                                  items: displayAllQuantityType(context),
                                  color: Colors.white,
                                  iconData: Icons.arrow_drop_down,
                                  foregroundColor: Colors.black,
                                ),
                              ),

                            ],
                          ),

                        ///Displays the PersonPicker
                        if (categoryDropDownValue ==
                            displayTextCategory(context, Categories.tasks))
                          PoamPersonPicker(
                            personNames: personNames,
                            pickedPerson: personDropDownValue,
                            onChange: (value) {
                              personDropDownValue = value!;
                            },
                            box: box,
                          ),

                        ///Displays the Date-Time-Picker
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding (
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [

                                ///Here can the user disable the DateTime
                                if (categoryDropDownValue ==
                                    displayTextCategory(
                                        context, Categories.tasks))
                                  PoamDateCheck(
                                    isChecked: isDateChecked,
                                    onCheckListener: (bool value) => isDateChecked = value,
                                  ),

                                if (categoryDropDownValue ==
                                    displayTextCategory(context, Categories.tasks) && isDateChecked != true)
                                  PoamDatePicker(
                                    title:
                                    AppLocalizations.of(context)!.dateFrom +
                                        ": ",
                                    dateController: _fromDateController,
                                    timeController: _fromTimeController,
                                    firstFromDatePicked: _firstFromDatePicked,
                                    firstFromTimePicked: _firstFromTimePicked,
                                    secondFromDateListener: (value) => _secondFromDatePicked = value,
                                    secondFromTimeListener: (value) => _secondFromTimePicked = value,
                                    EditMode: widget.isEditMode,
                                  ),
                                if (categoryDropDownValue ==
                                    displayTextCategory(context, Categories.tasks) && isDateChecked != true)
                                  PoamDatePicker(
                                    title: AppLocalizations.of(context)!.dateTo +
                                        ": ",
                                    dateController: _toDateController,
                                    timeController: _toTimeController,
                                    fromDate: _fromDateController.text != ""
                                        ? DateFormat.yMd(
                                        Localizations.localeOf(context)
                                            .languageCode)
                                        .parse(_fromDateController.text)
                                        : DateTime.now(),
                                    fromTime: _fromTimeController.text != ""
                                        ? DateFormat.Hm()
                                        .parse(_fromTimeController.text)
                                        : DateTime(0, 0, 0, DateTime.now().hour,
                                        DateTime.now().minute + 1),
                                    firstFromDateListener: (value) => _firstFromDatePicked = value,
                                    firstFromTimeListener: (value) => _firstFromTimePicked = value,
                                    secondFromDatePicked: _secondFromDatePicked,
                                    secondFromTimePicked: _secondFromTimePicked,
                                    EditMode: widget.isEditMode,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        ///Displays the Frequency DropDownMenu
                        if (categoryDropDownValue ==
                            displayTextCategory(context, Categories.tasks) && isDateChecked != true)
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

                        ///Displays the notification settings
                        if (categoryDropDownValue ==
                            displayTextCategory(context, Categories.tasks))
                          PoamNotification(
                            addAlarms: (value) => alarms.add(value),
                            removeAlarms: (value) => alarms.remove(value),
                            listOfAlarms: alarms,
                          ),

                        ///Displays the Color Picker
                        if (categoryDropDownValue ==
                            displayTextCategory(context, Categories.tasks))
                          PoamColorPicker(
                            pickedColor: selectedColor,
                            onChangeColor: (Color? color) {
                              //on color picked
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
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => ChartService(0, 0, DateTime(0)),
                      ),
                    ],
                    child: PoamPopMenu(
                      formKey: _formKey,
                      isEditMode: widget.isEditMode,
                      categoryDropDownValue: categoryDropDownValue,
                      quantityTypeDropwDownValue: quantityTypeDropwDownValue,
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
                      oldDateTime: widget.isEditMode == true ? widget.itemModel!.fromDate : DateTime(0),
                      alarms: Alarms(alarms),
                      allowDate: isDateChecked,
                      oldAllowDate: widget.itemModel != null ? widget.itemModel!.AllowDate : null,

                      ///if EditMode is true then get the index of this itemModel, else set the itemIndex to 0
                      itemIndex: widget.isEditMode == true
                          ? itemModel.indexOf(widget.itemModel!)
                          : 0,
                    ),)
                  ],
              ),
            ),
          );
        }
        );
  }
}
