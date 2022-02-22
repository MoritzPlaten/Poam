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

class PoamPopUp extends StatefulWidget {

  const PoamPopUp({Key? key}) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;
  TextEditingController titleTextFieldController = TextEditingController();
  TextEditingController numberTextFieldController = TextEditingController();
  TextEditingController personTextFieldController = TextEditingController();
  TextEditingController dateTextFieldController = TextEditingController();
  String categoryDropDownValue = displayTextCategory(Categories.values.first);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  Color selectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {

    ///Refresh Items
    context.watch<ItemModel>().getItems();

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
                ),

                const SizedBox(height: 10,),

                PoamTextField(
                  controllerCallback: titleTextFieldController,
                  label: "Title",
                ),

                const SizedBox(height: 10,),

                if (categoryDropDownValue == displayTextCategory(Categories.shopping))
                  PoamTextField(
                    controllerCallback: numberTextFieldController,
                    label: "Number",
                  ),

                if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                  PoamTextField(
                    controllerCallback: personTextFieldController,
                    label: "Person",
                  ),

                if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                PoamDatePicker(
                  dateController: _dateController,
                  timeController: _timeController,
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

              ],
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
                            if (titleTextFieldController.text != "") {
                              ///if select Category task, then you can add only tasks for the future
                              if (categoryDropDownValue == displayTextCategory(Categories.tasks)?
                              DateTime(int.parse(_dateController.text.split("/").last), int.parse(_dateController.text.split("/").first), int.parse(_dateController.text.split("/").elementAt(1)), int.parse(_timeController.text.split(":").first), int.parse(_timeController.text.split(":").last), DateTime.now().second).compareTo(DateTime.now()) >= 0 : true) {

                                Provider.of<ItemModel>(context, listen: false)
                                    .addItem(ItemModel(
                                    ///Set Title
                                    titleTextFieldController.text,
                                    ///Set the number. if number == "", then set number to 0
                                    numberTextFieldController.text != "" ? int.parse(numberTextFieldController.text) : 0,
                                    ///isChecked == false
                                    false,
                                    ///Person
                                    personTextFieldController.text != "" ? Person(personTextFieldController.text) : Person(""),
                                    ///Set Category
                                    categoryDropDownValue == "Aufgabenliste" ? Categories.tasks : Categories.shopping,
                                    ///Set Color
                                    selectedColor.value.toRadixString(16),
                                    ///Set Time
                                    DateTime(0, 0, 0, categoryDropDownValue == displayTextCategory(Categories.tasks) ? int.parse(_timeController.text.split(":").first) : 0, categoryDropDownValue == displayTextCategory(Categories.tasks) ? int.parse(_timeController.text.split(":").last) : 0),
                                    ///Set Date
                                    categoryDropDownValue == displayTextCategory(Categories.tasks) ? DateTime(int.parse(_dateController.text.split("/").last), int.parse(_dateController.text.split("/").first), int.parse(_dateController.text.split("/").elementAt(1))) : DateTime(0),
                                    ///Set Frequency
                                    Frequency.single)
                                );

                                Navigator.pop(context);
                              } else {

                                poamSnackbar.showSnackBar(context, "Sie können keine Aufgaben erstellen in der Vergangenheit!", primaryColor);
                              }
                            } else {

                              poamSnackbar.showSnackBar(context, "Geben Sie ein Title ein!", primaryColor);
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
