part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceMarked extends AttendanceState {}

class AttendanceNotMarked extends AttendanceState {}
