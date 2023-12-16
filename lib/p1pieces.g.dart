// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p1pieces.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class p1Adapter extends TypeAdapter<p1> {
  @override
  final int typeId = 1;

  @override
  p1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return p1(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, p1 obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idname)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.firstMove);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is p1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
