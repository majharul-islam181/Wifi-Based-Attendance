import 'package:workmanager/workmanager.dart';
import '../core/constant.dart';
import '../core/services/attendance_service.dart';
import '../core/services/wifi_services.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final wifiService = WifiService();
    final attendanceService = AttendanceService();

    final ssid = await wifiService.getCurrentSSID();
    final alreadyMarked = await attendanceService.hasMarkedAttendanceToday();

    if (ssid == companyWifiSSID && !alreadyMarked) {
      await attendanceService.markAttendance();
    }

    return Future.value(true);
  });
}
