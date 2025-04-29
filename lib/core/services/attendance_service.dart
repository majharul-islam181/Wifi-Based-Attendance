import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class AttendanceService {
  Future<bool> hasMarkedAttendanceToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    return prefs.getString(attendanceKey) == today;
  }

  Future<void> markAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    await prefs.setString(attendanceKey, today);
  }
}
