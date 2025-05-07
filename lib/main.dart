import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_attendance/models/attendance_log.dart';
import 'package:wifi_attendance/utils/AttendanceLogger_helper.dart';
import 'package:wifi_attendance/utils/background_task.dart';
import 'package:wifi_attendance/utils/notification_helper.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'core/services/wifi_services.dart';
import 'features/attendance/data/attendance_repository.dart';
import 'core/services/attendance_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(AttendanceLogAdapter());

  await Hive.openBox<AttendanceLog>('attendance_logs');

  await initializeService();
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "wifiCheckTask",
    "wifiCheckTask",
    frequency: Duration(minutes: 15),
  );

  final repository = AttendanceRepository(WifiService(), AttendanceService());

  runApp(MyApp(repository: repository));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}

Timer? timer;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // ✅ Initialize Hive in background isolate
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(AttendanceLogAdapter());
  }

  await Hive.openBox<AttendanceLog>('attendance_logs');

  timer = Timer.periodic(Duration(minutes: 1), (timer) async {
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
      await NotificationHelper.showNotification(
          "Attendance Marked", "You have been marked present 🎉");
    } else {
      await NotificationHelper.showNotification(
          "Attendance Checked", "Checked at ${DateTime.now()}");
    }
  });

  service.on('stopService').listen((event) {
    timer?.cancel();
  });
}
