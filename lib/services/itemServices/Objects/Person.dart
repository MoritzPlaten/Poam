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

  List<Person> _personList = <Person>[];
  List<Person> get PersonList => _personList;

  void getPersons() async {
    final box = await Hive.openBox<Person>(Database.PersonName);

    _personList = box.values.toList();
    notifyListeners();
  }

  void addPerson(Person person) async {

    final box = await Hive.openBox<Person>(Database.PersonName);
    box.add(person);
    notifyListeners();
  }

  Future<bool> isExists(Person person) async {
    bool isExists = false;

    final box = await Hive.openBox<Person>(Database.PersonName);
    List<Person> items = box.values.where((element) => element.name == person.name).toList();

    if (items.length != 0) {
      isExists = true;
    }

    return isExists;
  }

  void removePerson(int Index) async {

    final box = await Hive.openBox<Person>(Database.PersonName);
    box.deleteAt(Index);
    notifyListeners();
  }

}

List<String> getPersonsAsStrings(List<Person> persons) {
  List<String> personNames = List.generate(persons.length, (index) => "");

  int i = 0;
  persons.forEach((element) {
    personNames[i] = element.name!;
    i++;
  });

  return personNames;
}