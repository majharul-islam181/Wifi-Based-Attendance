part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAttendanceEvent extends AttendanceEvent {}
