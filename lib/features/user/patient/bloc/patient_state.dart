part of 'patient_bloc.dart';

@immutable
sealed class PatientState {}

final class PatientInitial extends PatientState {}

final class PatientLoading extends PatientState {}

final class PatientLoaded extends PatientState {
  final Patient patient;
  PatientLoaded({required this.patient});
}

final class PatientLoadingError extends PatientState {
  final String message;

  PatientLoadingError({required this.message});
}

final class DoctorsLoading extends PatientState {}

final class DoctorsLoaded extends PatientState {
  final List<Doctor> doctors;
  DoctorsLoaded({required this.doctors});
}

final class DoctorsLoadingError extends PatientState {
  final String message;

  DoctorsLoadingError({required this.message});
}

final class DoctorLoading extends PatientState {}

final class DoctorLoaded extends PatientState {
  final Doctor doctor;
  DoctorLoaded({required this.doctor});
}

final class DoctorLoadingError extends PatientState {
  final String message;

  DoctorLoadingError({required this.message});
}

final class VitalInfoLoading extends PatientState {}

final class VitalInfoLoaded extends PatientState {
  final VitalInfo vitalInfo;
  VitalInfoLoaded({required this.vitalInfo});
}

final class VitalInfoError extends PatientState {
  final String message;

  VitalInfoError({required this.message});
}

final class VitalInfoListLoading extends PatientState {}

final class VitalInfoListLoaded extends PatientState {
  final List<VitalInfo> vitalInfoList;
  VitalInfoListLoaded({required this.vitalInfoList});
}

final class VitalInfoListError extends PatientState {
  final String message;

  VitalInfoListError({required this.message});
}
