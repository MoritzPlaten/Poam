import 'package:flutter/material.dart';
import 'package:poam/services/itemServices/MenuService.dart';
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


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      scrollable: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: Column(
        children: [

          const Text(
            "Hinzufügen",
            style: TextStyle(
              fontSize: 20
            ),
          ),

          const SizedBox(height: 10,),

          TextField(
            obscureText: false,
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
              contentPadding: EdgeInsets.all(10)
            ),
          ),

          ElevatedButton(
              onPressed: () => {
                setState(() {
                  if (controller.text != "") {
                    Provider.of<MenuService>(context, listen: false).addItem(ItemModel().setItemModel(controller.text, 1, false, Person().setPersonModel("Moritz Platen"), Categories.tasks, "07/02/2022"));
                  }
                })
              },
              child: const Text("Add")
          ),

        ],
      )
    );
  }
}
