// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuantityType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuantityTypeAdapter extends TypeAdapter<QuantityType> {
  @override
  final int typeId = 7;

  @override
  QuantityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuantityType.Pieces;
      case 1:
        return QuantityType.Liter;
      default:
        return QuantityType.Pieces;
    }
  }

  @override
  void write(BinaryWriter writer, QuantityType obj) {
    switch (obj) {
      case QuantityType.Pieces:
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
