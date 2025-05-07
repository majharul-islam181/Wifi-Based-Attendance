import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_attendance/core/services/wifi_services.dart';
import 'package:wifi_attendance/features/attendance/logic/attendance_bloc.dart';
import 'package:wifi_attendance/models/attendance_log.dart';

import '../../../utils/AttendanceLogger_helper.dart';

/*
class AttendanceHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logs = AttendanceLogger.getLogs();

    return Scaffold(
      appBar: AppBar(title: Text("Attendance History")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            title: Text("${log.dateTime} → ${log.wifiName}"),
            subtitle: Text("Marked by: ${log.markedType}"),
          );
        },
      ),
    );
  }
}
*/
class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with WidgetsBindingObserver {
  String? currentWifiName;

  @override
  void initState() {
    super.initState();
    _fetchWifiName();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Re-open box to refresh (optional)
    Hive.box<AttendanceLog>('attendance_logs');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // ✅ remove observer when screen destroyed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
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
    final attendanceBox = Hive.box<AttendanceLog>('attendance_logs');

    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              if (state is AttendanceLoading)
                Center(child: CircularProgressIndicator())
              else if (state is AttendanceMarked)
                Center(child: Text('Attendance marked successfully 🎉'))
              else if (state is AttendanceNotMarked)
                Column(
                  children: [
                    Text('Not on company Wi-Fi or already marked.'),
                    SizedBox(height: 8),
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
                )
              else
                Column(
                  children: [
                    Text('Current Wi-Fi: ${currentWifiName ?? "Loading..."}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AttendanceBloc>()
                            .add(CheckAttendanceEvent());
                      },
                      child: Text('Check & Mark Attendance'),
                    ),
                  ],
                ),

              SizedBox(height: 24),
              Divider(),

              // History Section
              Text(
                "Attendance History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
/*
              ValueListenableBuilder(
                valueListenable: attendanceBox.listenable(),
                builder: (context, Box<AttendanceLog> box, _) {
                  final logs = box.values.toList().reversed.toList();

                  if (logs.isEmpty) {
                    return Text("No attendance history yet.");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return ListTile(
                        leading: Icon(
                          log.markedType == "manual"
                              ? Icons.person
                              : Icons.alarm,
                          color: log.markedType == "manual"
                              ? Colors.blue
                              : Colors.green,
                        ),
                        title: Text("${log.wifiName}"),
                        subtitle: Text("${log.markedType} - ${log.dateTime}"),
                      );
                    },
                  );
                },
              ),


              */

              StreamBuilder<void>(
                stream: AttendanceLogger.logStream,
                builder: (context, snapshot) {
                  final logs = attendanceBox.values.toList().reversed.toList();

                  if (logs.isEmpty) {
                    return Text("No attendance history yet.");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return ListTile(
                        leading: Icon(
                          log.markedType == "manual"
                              ? Icons.person
                              : Icons.alarm,
                          color: log.markedType == "manual"
                              ? Colors.blue
                              : Colors.green,
                        ),
                        title: Text("${log.wifiName}"),
                        subtitle: Text("${log.markedType} - ${log.dateTime}"),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
