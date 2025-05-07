import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_attendance/features/attendance/presentation/AttendanceHistoryPage.dart';
import 'features/attendance/data/attendance_repository.dart';
import 'features/attendance/logic/attendance_bloc.dart';
// import 'features/attendance/presentation/attendance_screen.dart';

class MyApp extends StatelessWidget {
  final AttendanceRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc(
        repository.wifiService, // Pass WifiService directly
        repository.attendanceService, // Pass AttendanceService directly
      ),
      child: MaterialApp(
          title: 'Wi-Fi Attendance',
          // home: AttendanceScreen(),
          home: AttendanceScreen()),
    );
  }
}
