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
