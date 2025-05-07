import 'package:flutter/foundation.dart';
import 'package:wifi_attendance/utils/AttendanceLogger_helper.dart';
import 'package:wifi_attendance/utils/notification_helper.dart';
import 'package:workmanager/workmanager.dart';
import '../core/services/attendance_service.dart';
import '../core/services/wifi_services.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final wifiService = WifiService();
    final attendanceService = AttendanceService();

    final ssid = await wifiService.getCurrentSSID();
    final alreadyMarked = await attendanceService.hasMarkedAttendanceToday();

    if (ssid == "Taghyeer" && !alreadyMarked) {
      await attendanceService.markAttendance();
      await AttendanceLogger.logAttendance(
        wifiName: ssid!,
        markedType: "auto",
      );
      if (kDebugMode) {
        print("[Workmanager] Attendance marked automatically!");
      }
      await NotificationHelper.showNotification(
          "Attendance Marked", "You have been marked present 🎉");
    } else {
      if (kDebugMode) {
        print("[Workmanager] Not on wifi or already marked");
      }
    }

    return Future.value(true);
  });
}
