// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Frequency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 3;

  @override
  Frequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Frequency.single;
      case 1:
        return Frequency.daily;
      case 2:
        return Frequency.weekly;
      case 3:
        return Frequency.monthly;
      case 4:
        return Frequency.yearly;
      default:
        return Frequency.single;
    }
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    switch (obj) {
      case Frequency.single:
        writer.writeByte(0);
        break;
      case Frequency.daily:
        writer.writeByte(1);
        break;
      case Frequency.weekly:
        writer.writeByte(2);
        break;
      case Frequency.monthly:
        writer.writeByte(3);
        break;
      case Frequency.yearly:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
