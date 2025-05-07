import 'dart:async';

import 'package:hive/hive.dart';
import 'package:wifi_attendance/models/attendance_log.dart';

class AttendanceLogger {
  static final Box<AttendanceLog> _box =
      Hive.box<AttendanceLog>('attendance_logs');
  static final StreamController<void> _logStreamController =
      StreamController.broadcast();

  static Stream<void> get logStream => _logStreamController.stream;

  static Future<void> logAttendance({
    required String wifiName,
    required String markedType,
  }) async {
    final log = AttendanceLog(
      dateTime: DateTime.now(),
      wifiName: wifiName,
      markedType: markedType,
    );

    await _box.add(log);

    // Notify listeners
    _logStreamController.add(null);
  }

  static List<AttendanceLog> getLogs() {
    return _box.values.toList().reversed.toList();
  }
}
