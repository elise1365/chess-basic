// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2pieces.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class p2Adapter extends TypeAdapter<p2> {
  @override
  final int typeId = 0;

  @override
  p2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return p2(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, p2 obj) {
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
      other is p2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
