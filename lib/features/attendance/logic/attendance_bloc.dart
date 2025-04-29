import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/services/wifi_services.dart';
import '../data/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

// class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
//   final AttendanceRepository repository;

//   AttendanceBloc(this.repository) : super(AttendanceInitial()) {
//     on<CheckAttendanceEvent>((event, emit) async {
//       emit(AttendanceLoading());
//       try {
//         final success = await repository.checkAndMarkAttendance();
//         if (success) {
//           emit(AttendanceMarked());
//         } else {
//           emit(AttendanceNotMarked());
//         }
//       } catch (e) {
//         print("Error in attendance: $e");
//         emit(AttendanceNotMarked());
//       }
//     });
//   }
// }

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final WifiService wifiService;
  final AttendanceService attendanceService;

  AttendanceBloc(this.wifiService, this.attendanceService)
      : super(AttendanceInitial()) {
    on<CheckAttendanceEvent>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final isConnected = await wifiService.checkAndMarkAttendance();
        if (isConnected) {
          // Mark attendance if connected to Wi-Fi
          await attendanceService.markAttendance();
          emit(AttendanceMarked());
        } else {
          emit(AttendanceNotMarked());
        }
      } catch (e) {
        print("Error marking attendance: $e");
        emit(AttendanceNotMarked());
      }
    });
  }
}
