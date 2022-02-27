import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/dateServices/Objects/Frequency.dart';
import '../../../services/itemServices/ItemModel.dart';
import '../../../services/itemServices/Objects/Category.dart';
import '../../../services/itemServices/Objects/Person.dart';
import '../../PoamSnackbar/PoamSnackbar.dart';

class PoamPopMenu extends StatefulWidget {

  final GlobalKey<FormState>? formKey;
  final String? categoryDropDownValue;
  final TextEditingController? numberController;
  final TextEditingController? titleController;
  final TextEditingController? personController;
  final TextEditingController? descriptionController;
  final Color? selectedColor;
  final String? frequencyDropDownValue;
  final TextEditingController? fromDateController;
  final TextEditingController? fromTimeController;
  final TextEditingController? toDateController;
  final TextEditingController? toTimeController;

  const PoamPopMenu({Key? key, this.formKey, this.categoryDropDownValue, this.numberController, this.titleController,
    this.personController, this.selectedColor, this.frequencyDropDownValue, this.descriptionController, this.fromDateController,
    this.fromTimeController, this.toDateController, this.toTimeController }) : super(key: key);

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
                    if (widget.formKey!.currentState!.validate() && widget.titleController!.text != "") {
                      bool isProblem = false;

                      ///if select Category task, then you can add only tasks for the future
                      if (widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.fromDateController!.text != "" && widget.fromTimeController!.text != "" ?
                      DateTime(int.parse(widget.fromDateController!.text.split("/").last),
                          int.parse(widget.fromDateController!.text.split("/").first),
                          int.parse(widget.fromDateController!.text.split("/").elementAt(1)),
                          int.parse(widget.fromTimeController!.text.split(":").first),
                          int.parse(widget.fromTimeController!.text.split(":").last),
                          DateTime.now().second).compareTo(DateTime.now()) /*>=*/ < 0 : false) {
                        poamSnackbar.showSnackBar(context,
                            "Sie können keine Aufgaben erstellen in der Vergangenheit!",
                            primaryColor);
                        isProblem = true;
                      }

                      RegExp regExp = new RegExp(r'^[0-9]+$');
                      if (widget.categoryDropDownValue == displayTextCategory(Categories.shopping) && regExp.hasMatch(widget.numberController!.text) == false) {
                        poamSnackbar.showSnackBar(context,
                            "Geben Sie eine Zahl ein, keine Buchstaben!",
                            primaryColor);
                        isProblem = true;
                      }

                      ///TODO: if toDate > fromDate && toTime > fromDate then error

                      ///If there are no problems then add ItemModel
                      if (isProblem == false) {
                        Provider.of<ItemModel>(context, listen: false).addItem(ItemModel(

                          ///Set Title
                            widget.titleController!.text,

                            ///Set the number. if number == "", then set number to 0
                            widget.categoryDropDownValue == displayTextCategory(Categories.shopping) ? int.parse(widget.numberController!.text) : 0,

                            ///isChecked == false
                            false,

                            ///Person
                            Person(widget.personController!.text),

                            ///Set Category
                            widget.categoryDropDownValue == "Aufgabenliste"
                                ? Categories.tasks
                                : Categories.shopping,

                            ///Set Color
                            widget.selectedColor!.value.toRadixString(16),

                            ///Set From Time
                            DateTime(0, 0, 0,
                                widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.fromTimeController!.text != "" ?
                                int.parse(widget.fromTimeController!.text.split(":").first)
                                    :
                                DateTime.now().hour,
                                widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.fromTimeController!.text != "" ?
                                int.parse(widget.fromTimeController!.text.split(":").last)
                                    :
                                DateTime.now().minute),

                            ///Set From Date
                            widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.fromDateController!.text != "" ?
                            DateTime(
                                int.parse(widget.fromDateController!.text.split("/").last),
                                int.parse(widget.fromDateController!.text.split("/").first),
                                int.parse(widget.fromDateController!.text.split("/").elementAt(1))) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),

                            ///Set to Time
                            DateTime(0, 0, 0,
                                widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.fromTimeController!.text != "" ?
                                int.parse(widget.toTimeController!.text.split(":").first)
                                    :
                                DateTime.now().hour,
                                widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.toTimeController!.text != "" ?
                                int.parse(widget.toTimeController!.text.split(":").last)
                                    :
                                DateTime.now().minute),

                            ///Set to Date
                            widget.categoryDropDownValue == displayTextCategory(Categories.tasks) && widget.toDateController!.text != "" ?
                            DateTime(
                                int.parse(widget.toDateController!.text.split("/").last),
                                int.parse(widget.toDateController!.text.split("/").first),
                                int.parse(widget.toDateController!.text.split("/").elementAt(1))) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),

                            ///Set Frequency
                            getFrequency(widget.frequencyDropDownValue!),
                            ///Description
                            widget.descriptionController!.text,
                            ///Set Expanded
                            false
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
    );
  }
}
