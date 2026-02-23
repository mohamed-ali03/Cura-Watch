part of 'patient_bloc.dart';

@immutable
sealed class PatientState {}

final class PatientInitial extends PatientState {}

final class PatientStateLoading extends PatientState {}

final class PatientStateSuccess extends PatientState {
  final Patient? patient;
  final VitalInfo? vitalInfo;
  final List<VitalInfo>? vitalInfoList;

  final String? message;

  PatientStateSuccess({
    this.patient,
    this.vitalInfo,
    this.message,
    this.vitalInfoList,
  });
}

final class PatientStateError extends PatientState {
  final String message;

  PatientStateError(this.message);
}
