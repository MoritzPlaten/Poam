import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/Objects/Category.dart';
import 'package:poam/services/itemServices/Objects/ItemModel.dart';
import 'package:poam/services/itemServices/Objects/Person.dart';
import 'package:provider/provider.dart';

class PoamPopUp extends StatefulWidget {

  const PoamPopUp({Key? key}) : super(key: key);

  @override
  _PoamPopUpState createState() => _PoamPopUpState();
}

class _PoamPopUpState extends State<PoamPopUp> {

  late Color primaryColor;
  late TextEditingController titleTextFieldController = TextEditingController();
  late TextEditingController numberTextFieldController = TextEditingController();
  late TextEditingController personTextFieldController = TextEditingController();
  late TextEditingController dateTextFieldController = TextEditingController();
  String dropdownValue = displayTextCategory(Categories.values.first);

  @override
  Widget build(BuildContext context) {

    ///initialize
    context.watch<ItemModel>().getItems();
    final size = MediaQuery.of(context).size;
    primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(

          children: [

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
                              Provider.of<ItemModel>(context, listen: false).addItem(ItemModel(titleTextFieldController.text, numberTextFieldController.text != "" ? int.parse(numberTextFieldController.text) : 0, false, personTextFieldController.text != "" ? Person(personTextFieldController.text) : Person(""), dropdownValue == "Aufgabenliste" ? Categories.tasks : Categories.shopping, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
                              Navigator.pop(context);
                            } else {

                            }
                          })
                        },
                      ),
                    ],
                  ),
                )
            ),

            ///The Form
            ListView(
              padding: const EdgeInsets.only(top: 60, right: 10, left: 10, bottom: 10),
              shrinkWrap: true,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    value: dropdownValue,

                    // Hide the default underline
                    underline: Container(),
                    isExpanded: true,

                    // The list of options
                    items: displayAllCategories() /// Gets all Categories in a List<String>
                        .map((e) => DropdownMenuItem(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      value: e,
                    ))
                        .toList(),

                    // Customize the selected item
                    selectedItemBuilder: (BuildContext context) => displayAllCategories()
                        .map((e) => Center(
                      child: Text(
                        e,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 10,),

                TextField(
                  controller: titleTextFieldController,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      contentPadding: EdgeInsets.all(10)
                  ),
                ),

                const SizedBox(height: 10,),

                if (dropdownValue == displayTextCategory(Categories.shopping))
                  TextField(
                  controller: numberTextFieldController,
                  decoration: const InputDecoration(
                      labelText: 'Number',
                      contentPadding: EdgeInsets.all(10)
                  ),
                ),

                if (dropdownValue == displayTextCategory(Categories.tasks))
                  TextField(
                    controller: personTextFieldController,
                    decoration: const InputDecoration(
                        labelText: 'Person',
                        contentPadding: EdgeInsets.all(10)
                    ),
                  ),

                if (dropdownValue == displayTextCategory(Categories.tasks))
                  TextField(
                    controller: dateTextFieldController,
                    decoration: const InputDecoration(
                        labelText: 'Datum',
                        contentPadding: EdgeInsets.all(10)
                    ),
                  ),

              ],
            ),

          ],
        ),
      )
    );
  }
}
