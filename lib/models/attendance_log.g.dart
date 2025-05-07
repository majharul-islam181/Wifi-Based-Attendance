// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceLogAdapter extends TypeAdapter<AttendanceLog> {
  @override
  final int typeId = 0;

  @override
  AttendanceLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceLog(
      dateTime: fields[0] as DateTime,
      wifiName: fields[1] as String,
      markedType: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.wifiName)
      ..writeByte(2)
      ..write(obj.markedType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
