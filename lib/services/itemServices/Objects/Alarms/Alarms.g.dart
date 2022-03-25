// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Alarms.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmsAdapter extends TypeAdapter<Alarms> {
  @override
  final int typeId = 9;

  @override
  Alarms read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarms(
      (fields[0] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, Alarms obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.listOfAlarms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
