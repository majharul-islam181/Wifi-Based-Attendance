import 'package:hive/hive.dart';

part 'attendance_log.g.dart';

@HiveType(typeId: 0)
class AttendanceLog extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  String wifiName;

  @HiveField(2)
  String markedType; // "auto" or "manual"

  AttendanceLog({
    required this.dateTime,
    required this.wifiName,
    required this.markedType,
  });
}
