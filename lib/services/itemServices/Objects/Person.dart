import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'Database.dart';

part 'Person.g.dart';

@HiveType(typeId: 1)
class Person extends ChangeNotifier {

  @HiveField(0)
  String? name;

  @HiveField(1)
  Person(this.name);

  List _personList = <Person>[];
  List get PersonList => _personList;

  void getPersons(Person person) async {

    final box = await Hive.openBox<Person>(Database.PersonName);
    _personList = box.values.toList();

    notifyListeners();
  }

  void addPerson(Person person) async {

    final box = await Hive.openBox<Person>(Database.PersonName);
    box.add(person);
    notifyListeners();
  }

  void removePerson(Person person) async {

    final box = await Hive.openBox<Person>(Database.PersonName);
    box.deleteAt(_personList.indexOf(person));
    notifyListeners();
  }

}