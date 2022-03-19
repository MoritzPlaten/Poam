// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Amounts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmountsAdapter extends TypeAdapter<Amounts> {
  @override
  final int typeId = 8;

  @override
  Amounts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Amounts(
      fields[0] as int?,
      fields[1] as QuantityType?,
    );
  }

  @override
  void write(BinaryWriter writer, Amounts obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.Number)
      ..writeByte(1)
      ..write(obj.quantityType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmountsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuantityTypeAdapter extends TypeAdapter<QuantityType> {
  @override
  final int typeId = 7;

  @override
  QuantityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuantityType.Number;
      case 1:
        return QuantityType.Liter;
      default:
        return QuantityType.Number;
    }
  }

  @override
  void write(BinaryWriter writer, QuantityType obj) {
    switch (obj) {
      case QuantityType.Number:
        writer.writeByte(0);
        break;
      case QuantityType.Liter:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuantityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
