// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChartService.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartServiceAdapter extends TypeAdapter<ChartService> {
  @override
  final int typeId = 5;

  @override
  ChartService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartService(
      fields[1] as int,
      fields[0] as int,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChartService obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isNotChecked)
      ..writeByte(1)
      ..write(obj.isChecked)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
