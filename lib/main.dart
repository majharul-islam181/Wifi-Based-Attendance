import 'package:flutter/material.dart';
import 'package:wifi_attendance/utils/background_task.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'core/services/wifi_services.dart';
import 'features/attendance/data/attendance_repository.dart';
import 'core/services/attendance_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the background task
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    'wifiCheckTask',
    'wifiCheckTask',
    frequency: Duration(minutes: 15),
  );

  final repository = AttendanceRepository(WifiService(), AttendanceService());

  runApp(MyApp(repository: repository));
}
