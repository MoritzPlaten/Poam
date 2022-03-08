// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Locales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalesAdapter extends TypeAdapter<Locales> {
  @override
  final int typeId = 4;

  @override
  Locales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Locales(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Locales obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.locale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
