part of 'doctor_bloc.dart';

@immutable
sealed class DoctorState {}

final class DoctorInitial extends DoctorState {}

final class GetAllDoctorLoading extends DoctorState {}

final class GetAllDoctorLoaded extends DoctorState {
  final List<Doctor> doctors;
  GetAllDoctorLoaded({required this.doctors});
}

final class DoctorError extends DoctorState {
  final String message;
  DoctorError({required this.message});
}

final class GetCurrentDoctorLoading extends DoctorState {}

final class GetCurrentDoctorLoaded extends DoctorState {
  final Doctor doctor;
  GetCurrentDoctorLoaded({required this.doctor});
}

final class GetDoctorLoading extends DoctorState {}

final class GetDoctorLoaded extends DoctorState {
  final Doctor doctor;
  GetDoctorLoaded({required this.doctor});
}

final class EditDoctorInfoLoading extends DoctorState {}

final class EditDoctorInfoLoaded extends DoctorState {
  final Doctor doctor;
  EditDoctorInfoLoaded({required this.doctor});
}

final class GetAssignedPatientLoading extends DoctorState {}

final class GetAssignedPatientLoaded extends DoctorState {
  final List<Patient> patients;
  GetAssignedPatientLoaded({required this.patients});
}

final class DoctorVitalInfoListLoading extends DoctorState {}

final class DoctorVitalInfoListLoaded extends DoctorState {
  final List<dynamic> vitalInfoList;
  DoctorVitalInfoListLoaded({required this.vitalInfoList});
}
