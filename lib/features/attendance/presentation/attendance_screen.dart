import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/services/wifi_services.dart';
import '../logic/attendance_bloc.dart';

// Manually show attendance
/*
class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? currentWifiName;

  @override
  void initState() {
    super.initState();
    _fetchWifiName();
  }

  Future<void> _fetchWifiName() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      final wifiName = await WifiService().getCurrentSSID();
      setState(() {
        currentWifiName = wifiName ?? "Unknown";
      });
    } else {
      setState(() {
        currentWifiName = "Permission denied";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AttendanceMarked) {
            return Center(child: Text('Attendance marked successfully 🎉'));
          } else if (state is AttendanceNotMarked) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not on company Wi-Fi or already marked.'),
                  SizedBox(height: 16),
                  Text('Current Wi-Fi: ${currentWifiName ?? "Loading..."}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AttendanceBloc>()
                          .add(CheckAttendanceEvent());
                    },
                    child: Text('Retry Attendance'),
                  ),
                ],
              ),
            );
          }

          // Default UI if no specific state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current Wi-Fi: ${currentWifiName ?? "Loading..."}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AttendanceBloc>().add(CheckAttendanceEvent());
                  },
                  child: Text('Check & Mark Attendance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/

// Automatically show attendance

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? currentWifiName;

  @override
  void initState() {
    super.initState();
    _fetchWifiName();
  }

  // Function to fetch Wi-Fi SSID and check attendance
  Future<void> _fetchWifiName() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      final wifiName = await WifiService().getCurrentSSID();
      setState(() {
        currentWifiName = wifiName ?? "Unknown";
      });

      // Check and mark attendance if connected to company Wi-Fi
      if (wifiName != null && wifiName == 'Taghyeer') {
        context.read<AttendanceBloc>().add(CheckAttendanceEvent());
      }
    } else {
      setState(() {
        currentWifiName = "Permission denied";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AttendanceMarked) {
            return Center(child: Text('Attendance marked successfully 🎉'));
          } else if (state is AttendanceNotMarked) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not on company Wi-Fi or already marked.'),
                  SizedBox(height: 16),
                  Text('Current Wi-Fi: ${currentWifiName ?? "Loading..."}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AttendanceBloc>()
                          .add(CheckAttendanceEvent());
                    },
                    child: Text('Retry Attendance'),
                  ),
                ],
              ),
            );
          }

          // Default UI if no specific state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current Wi-Fi: ${currentWifiName ?? "Loading..."}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AttendanceBloc>().add(CheckAttendanceEvent());
                  },
                  child: Text('Check & Mark Attendance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
