import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../../keyServices/KeyService.dart';
import '../Database.dart';

part 'Person.g.dart';

@HiveType(typeId: 1)
class Person extends ChangeNotifier {

  @HiveField(0)
  String? name;

  @HiveField(1)
  Person(this.name);

  List<Person> _personList = <Person>[];
  List<Person> get PersonList => _personList;

  Future<List<int>> getPersonKey() async {

    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: KeyService.PersonKey);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: KeyService.PersonKey, value: base64UrlEncode(key));
    }

    String? read = await secureStorage.read(key: KeyService.PersonKey);

    var encryptionKey = base64Url.decode(read!);
    return encryptionKey;
  }

  void getPersons() async {
    var personKey = await getPersonKey();
    final box = await Hive.openBox<Person>(Database.PersonName, encryptionCipher: HiveAesCipher(personKey));

    _personList = box.values.toList();
    //notifyListeners();
  }

  void addPerson(Person person) async {

    var personKey = await getPersonKey();
    final box = await Hive.openBox<Person>(Database.PersonName, encryptionCipher: HiveAesCipher(personKey));
    box.add(person);
    notifyListeners();
  }

  Future<bool> isExists(Person person) async {
    bool isExists = false;

    var personKey = await getPersonKey();
    final box = await Hive.openBox<Person>(Database.PersonName, encryptionCipher: HiveAesCipher(personKey));
    List<Person> items = box.values.where((element) => element.name == person.name).toList();

    if (items.length != 0) {
      isExists = true;
    }

    return isExists;
  }

  void removePerson(int Index) async {

    var personKey = await getPersonKey();
    final box = await Hive.openBox<Person>(Database.PersonName, encryptionCipher: HiveAesCipher(personKey));
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