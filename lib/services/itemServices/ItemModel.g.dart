// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ItemModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 0;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      fields[0] as String,
      fields[1] as Amounts,
      fields[2] as bool,
      fields[3] as Person,
      fields[4] as Categories,
      fields[5] as String,
      fields[6] as DateTime,
      fields[7] as DateTime,
      fields[8] as DateTime,
      fields[9] as DateTime,
      fields[10] as Frequency,
      fields[11] as String,
      fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.amounts)
      ..writeByte(2)
      ..write(obj.isChecked)
      ..writeByte(3)
      ..write(obj.person)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.hex)
      ..writeByte(6)
      ..write(obj.fromTime)
      ..writeByte(7)
      ..write(obj.fromDate)
      ..writeByte(8)
      ..write(obj.toTime)
      ..writeByte(9)
      ..write(obj.toDate)
      ..writeByte(10)
      ..write(obj.frequency)
      ..writeByte(11)
      ..write(obj.description)
      ..writeByte(12)
      ..write(obj.expanded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
