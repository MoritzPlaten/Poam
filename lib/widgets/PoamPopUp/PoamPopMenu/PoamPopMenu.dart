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
  final String? numberValue;
  final String? titleValue;
  final String? personValue;
  final Color? selectedColor;
  final String? frequencyDropDownValue;
  final String? descriptionValue;
  final TextEditingController? dateController;
  final TextEditingController? timeController;

  const PoamPopMenu({Key? key, this.formKey, this.categoryDropDownValue, this.numberValue, this.titleValue,
    this.personValue, this.selectedColor, this.frequencyDropDownValue, this.descriptionValue, this.dateController,
    this.timeController}) : super(key: key);

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
                    if (widget.formKey!.currentState!.validate()) {
                      bool isProblem = false;

                      ///if select Category task, then you can add only tasks for the future
                      if (widget.categoryDropDownValue ==
                          displayTextCategory(Categories.tasks) &&
                          widget.dateController!.text != "" &&
                          widget.timeController!.text != "" ?
                      DateTime(int.parse(widget.dateController!.text
                          .split("/")
                          .last),
                          int.parse(widget.dateController!.text
                              .split("/")
                              .first),
                          int.parse(
                              widget.dateController!.text.split("/").elementAt(
                                  1)),
                          int.parse(widget.timeController!.text
                              .split(":")
                              .first),
                          int.parse(widget.timeController!.text
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
                      if (widget.categoryDropDownValue ==
                          displayTextCategory(Categories.shopping) &&
                          regExp.hasMatch(widget.numberValue!) == false) {
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
                            widget.titleValue!,

                            ///Set the number. if number == "", then set number to 0
                            widget.categoryDropDownValue ==
                                displayTextCategory(Categories.shopping)
                                ? int.parse(widget.numberValue!)
                                : 0,

                            ///isChecked == false
                            false,

                            ///Person
                            Person(widget.personValue),

                            ///Set Category
                            widget.categoryDropDownValue == "Aufgabenliste"
                                ? Categories.tasks
                                : Categories.shopping,

                            ///Set Color
                            widget.selectedColor!.value.toRadixString(16),

                            ///Set Time
                            DateTime(0, 0, 0,
                                widget.categoryDropDownValue ==
                                    displayTextCategory(
                                        Categories.tasks) &&
                                    widget.timeController!.text != "" ?
                                int.parse(widget.timeController!.text
                                    .split(":")
                                    .first)
                                    :
                                DateTime
                                    .now()
                                    .hour,
                                widget.categoryDropDownValue ==
                                    displayTextCategory(
                                        Categories.tasks) &&
                                    widget.timeController!.text != "" ?
                                int.parse(widget.timeController!.text
                                    .split(":")
                                    .last)
                                    :
                                DateTime
                                    .now()
                                    .minute + 1),

                            ///Set Date
                            widget.categoryDropDownValue ==
                                displayTextCategory(Categories.tasks) &&
                                widget.dateController!.text != "" ?
                            DateTime(
                                int.parse(widget.dateController!.text
                                    .split("/")
                                    .last),
                                int.parse(widget.dateController!.text
                                    .split("/")
                                    .first),
                                int.parse(
                                    widget.dateController!.text.split("/")
                                        .elementAt(1)))
                                : DateTime.now(),

                            ///Set Frequency
                            getFrequency(widget.frequencyDropDownValue!),
                            ///Description
                            widget.descriptionValue!
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
