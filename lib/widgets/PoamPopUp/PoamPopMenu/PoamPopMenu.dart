import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/dateServices/Objects/Frequency.dart';
import '../../../services/itemServices/ItemModel.dart';
import '../../../services/itemServices/Objects/Category.dart';
import '../../../services/itemServices/Objects/Person.dart';
import '../../PoamSnackbar/PoamSnackbar.dart';

class PoamPopMenu extends StatefulWidget {

  final GlobalKey<FormState>? formKey;
  final bool? isEditMode;
  final String? categoryDropDownValue;
  final TextEditingController? numberController;
  final TextEditingController? titleController;
  final String? personValue;
  final TextEditingController? descriptionController;
  final Color? selectedColor;
  final String? frequencyDropDownValue;
  final TextEditingController? fromDateController;
  final TextEditingController? fromTimeController;
  final TextEditingController? toDateController;
  final TextEditingController? toTimeController;
  final int? itemIndex;

  const PoamPopMenu({Key? key, this.formKey, this.isEditMode, this.categoryDropDownValue, this.numberController, this.titleController,
    this.personValue, this.selectedColor, this.frequencyDropDownValue, this.descriptionController, this.fromDateController,
    this.fromTimeController, this.toDateController, this.toTimeController, this.itemIndex }) : super(key: key);

  @override
  _PoamPopMenuState createState() => _PoamPopMenuState();
}

class _PoamPopMenuState extends State<PoamPopMenu> {

  late Size size;
  late Color primaryColor;
  late PoamSnackbar poamSnackbar;

  @override
  Widget build(BuildContext context) {

    ///initialize
    poamSnackbar = PoamSnackbar();
    size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;

    return Positioned(

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
                  Navigator.pop(context)
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
                    if (widget.formKey!.currentState!.validate()) {
                      bool isProblem = false;

                      DateTime _fromDate;
                      DateTime _toDate;

                      if (widget.fromDateController!.text != "") { _fromDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.fromDateController!.text); }
                      else { _fromDate = DateTime.now(); }
                      if (widget.toDateController!.text != "") { _toDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.toDateController!.text); }
                      else { _toDate = DateTime.now(); }

                      DateTime fromDateTime = widget.categoryDropDownValue == displayTextCategory(context, Categories.tasks) ? DateTime(
                          _fromDate.year,
                          _fromDate.month,
                          _fromDate.day,
                          widget.fromTimeController!.text != "" ? int.parse(widget.fromTimeController!.text.split(":").first) : DateTime.now().hour,
                          widget.fromTimeController!.text != "" ? int.parse(widget.fromTimeController!.text.split(":").last) : DateTime.now().minute + 1,
                          DateTime.now().second) : DateTime.now();

                      DateTime toDateTime = widget.categoryDropDownValue == displayTextCategory(context, Categories.tasks) ? DateTime(
                          _toDate.year,
                          _toDate.month,
                          _toDate.day,
                          widget.toTimeController!.text != "" ? int.parse(widget.toTimeController!.text.split(":").first) : DateTime.now().hour,
                          widget.toTimeController!.text != "" ? int.parse(widget.toTimeController!.text.split(":").last) : DateTime.now().minute + 1,
                          DateTime.now().second) : DateTime.now();

                      ///if select Category task, then you can add only tasks for the future
                      if (widget.categoryDropDownValue == displayTextCategory(context, Categories.tasks) ? fromDateTime.compareTo(DateTime.now()) /*>=*/ < 0 : false) {
                        poamSnackbar.showSnackBar(context,
                            AppLocalizations.of(context)!.messagePast,
                            primaryColor);
                        isProblem = true;
                      }

                      RegExp regExp = new RegExp(r'^[0-9]+$');
                      ///Message: Only Number else error
                      if (widget.categoryDropDownValue == displayTextCategory(context, Categories.shopping) && regExp.hasMatch(widget.numberController!.text) == false) {
                        poamSnackbar.showSnackBar(context,
                            AppLocalizations.of(context)!.messageOnlyNumber,
                            primaryColor);
                        isProblem = true;
                      }

                      ///Message: From Time is smaller than to Time
                      if (fromDateTime.compareTo(toDateTime) > 0) {
                        poamSnackbar.showSnackBar(context,
                            AppLocalizations.of(context)!.messageFromToTime,
                            primaryColor);

                        isProblem = true;
                      }

                      ///Message: A Person must be create
                      if (widget.personValue == "") {
                        poamSnackbar.showSnackBar(context,
                            AppLocalizations.of(context)!.messagePerson,
                            primaryColor);

                        isProblem = true;
                      }

                      ///If there are no problems then add ItemModel
                      if (isProblem == false) {

                        ItemModel itemModel = ItemModel(

                          ///Set Title
                            widget.titleController!.text.trim(),

                            ///Set the number. if number == "", then set number to 0
                            widget.categoryDropDownValue == displayTextCategory(context, Categories.shopping) ? int.parse(widget.numberController!.text.trim()) : 0,

                            ///isChecked == false
                            false,

                            ///Person
                            Person(widget.personValue!.trim()),

                            ///Set Category
                            widget.categoryDropDownValue == AppLocalizations.of(context)!.taskList
                                ? Categories.tasks
                                : Categories.shopping,

                            ///Set Color
                            widget.selectedColor!.value.toRadixString(16),

                            ///Set From Time
                            DateTime(0, 0, 0, fromDateTime.hour, fromDateTime.minute),

                            ///Set From Date
                            DateTime(fromDateTime.year, fromDateTime.month, fromDateTime.day),

                            ///Set to Time
                            DateTime(0, 0, 0, toDateTime.hour, toDateTime.minute),

                            ///Set to Date
                            DateTime(toDateTime.year, toDateTime.month, toDateTime.day),

                            ///Set Frequency
                            getFrequency(context, widget.frequencyDropDownValue!),
                            ///Description
                            widget.descriptionController!.text.trim(),
                            ///Set Expanded
                            false
                        );

                        switch (widget.isEditMode) {

                          ///Edit the ItemModel
                          case true:
                            Provider.of<ItemModel>(context, listen: false).putItem(
                                widget.itemIndex!,
                                itemModel
                            );
                            break;

                            ///Add a ItemModel
                          case false:
                            Provider.of<ItemModel>(context, listen: false).addItem(itemModel);
                            break;

                            ///Error
                          default:
                            print("Error");
                            break;
                        }

                        Navigator.pop(context);
                      }

                    }
                  })
                },
              ),
            ],
          ),
        )
    );
  }
}
