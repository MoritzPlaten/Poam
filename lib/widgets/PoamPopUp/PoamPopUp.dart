import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:poam/widgets/PoamColorPicker/PoamColorPicker.dart';
import 'package:poam/widgets/PoamDatePicker/PoamDatePicker.dart';
import 'package:poam/widgets/PoamDropDown/PoamDropDown.dart';
import 'package:poam/widgets/PoamSnackbar/PoamSnackbar.dart';
import 'package:poam/widgets/PoamTextField/PoamTextField.dart';
import 'package:provider/provider.dart';

class PoamPopUp extends StatefulWidget {

  const PoamPopUp({Key? key}) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late PoamSnackbar poamSnackbar;
  late Size size;
  late TextEditingController titleTextFieldController = TextEditingController();
  late TextEditingController numberTextFieldController = TextEditingController();
  late TextEditingController personTextFieldController = TextEditingController();
  late TextEditingController dateTextFieldController = TextEditingController();
  String categoryDropDownValue = displayTextCategory(Categories.values.first);
  int selectedDay = 1, selectedMonth = 1;
  Color screenPickerColor = Color(0xff443a49);

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

            ///The Form
            ListView(
              padding: const EdgeInsets.only(top: 60, right: 10, left: 10, bottom: 10),
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
                  iconData: Icons.arrow_drop_down_outlined,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("Day: "),

                      DropdownButton(
                        value: selectedDay,
                        items: [
                          for(int i = 1;i < 32;i++)
                          DropdownMenuItem(
                            child: Text(i.toString()),
                            value: i,
                          ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            selectedDay = value!;
                          });
                        }),

                      Text("Month: "),

                      DropdownButton(
                        value: selectedMonth,
                        items: [
                          for(int i = 1;i < 13;i++)
                            DropdownMenuItem(
                              child: Text(i.toString()),
                              value: i,
                            ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            selectedMonth = value!;
                          });
                        }),

                    ],
                  ),
                /*
                PoamDatePicker(
                    dateValue: selectedDay,
                    onDateChanged: (String? value) {
                      setState(() {
                        selectedDay = int.parse(value!);
                      });
                    },
                    monthValue: selectedMonth,
                    onMonthChanged: (String? value) {
                      setState(() {
                        selectedDay = int.parse(value!);
                      });
                    },
                  ),
                */

                if (categoryDropDownValue == displayTextCategory(Categories.tasks))
                  PoamColorPicker(),

              ],
            ),


            Positioned(

                bottom: 50,
                right: size.width - (size.width / 2) -50,

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
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)],
                              gradient: RadialGradient(
                                  radius: 0.9,
                                  center: const Alignment(0.7, -0.6),
                                  colors: [primaryColor, primaryColor.withRed(180).withBlue(140)],
                                  stops: const [0.1, 0.8]
                              ),
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
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)],
                              gradient: RadialGradient(
                                  radius: 0.9,
                                  center: const Alignment(0.7, -0.6),
                                  colors: [primaryColor, primaryColor.withRed(180).withBlue(140)],
                                  stops: const [0.1, 0.8]
                              ),
                            ),
                          ),
                        ),
                        onTap: () => {
                          setState(() {
                            ///Add Item
                            if (titleTextFieldController.text != "") {
                              ///TODO: can add task today
                              ///if select Category task, then you can add only tasks for the future
                              if (categoryDropDownValue == displayTextCategory(Categories.tasks)?
                              DateTime(DateTime.now().year, selectedMonth, selectedDay, DateTime.now().hour, DateTime.now().minute, DateTime.now().second).compareTo(DateTime.now()) >= 0 : true) {

                                Provider.of<ItemModel>(context, listen: false).addItem(ItemModel(titleTextFieldController.text, numberTextFieldController.text != "" ? int.parse(numberTextFieldController.text) : 0, false, personTextFieldController.text != "" ? Person(personTextFieldController.text) : Person(""), categoryDropDownValue == "Aufgabenliste" ? Categories.tasks : Categories.shopping, /*ColorToHex(screenPickerColor).hex*/"#ff0000", DateTime(DateTime.now().year, selectedMonth, selectedDay)));
                                Navigator.pop(context);
                              } else {

                                poamSnackbar.showSnackBar(context, "Sie keine Aufgaben erstellen in der Vergangenheit!", primaryColor);
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
