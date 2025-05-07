import '../../../core/services/attendance_service.dart';
import '../../../core/services/wifi_services.dart';

class AttendanceRepository {
  final WifiService _wifiService;
  final AttendanceService _attendanceService;

  AttendanceRepository(this._wifiService, this._attendanceService);

  Future<bool> checkAndMarkAttendance() async {
    // Check the current Wi-Fi SSID
    final ssid = await _wifiService.getCurrentSSID();
    // Check if attendance has already been marked for today
    final alreadyMarked = await _attendanceService.hasMarkedAttendanceToday();

    // If connected to the right Wi-Fi and attendance hasn't been marked today
    if (ssid == 'Taghyeer' && !alreadyMarked) {
      // Mark attendance
      await _attendanceService.markAttendance();
      return true; // Attendance successfully marked
    }

    return false; // Either not on the correct Wi-Fi or already marked attendance
  }

  // Optionally, you can create getters to access the services
  WifiService get wifiService => _wifiService;
  AttendanceService get attendanceService => _attendanceService;
}
