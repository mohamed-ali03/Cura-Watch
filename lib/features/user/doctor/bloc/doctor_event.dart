part of 'doctor_bloc.dart';

@immutable
sealed class DoctorEvent {}

final class GetAllDoctorsEvent extends DoctorEvent {}

final class GetCurrentDoctorEvent extends DoctorEvent {}

final class GetDoctorEvent extends DoctorEvent {
  final String id;
  GetDoctorEvent({required this.id});
}

final class EditDoctorEvent extends DoctorEvent {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final Map<String, dynamic>? availableHours;
  EditDoctorEvent({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.availableHours,
  });
}

final class GetAssignedPatient extends DoctorEvent {}

final class DoctorVitalReportEvent extends DoctorEvent {
  final String range;
  final DateTime? date;
  final String patientId;
  DoctorVitalReportEvent({
    required this.range,
    required this.patientId,
    this.date,
  });
}

final class MarkNotificationReadEvent extends DoctorEvent {
  final String id;
  MarkNotificationReadEvent({required this.id});
}

final class GetPatientByIdEvent extends DoctorEvent {
  final String patientId;
  GetPatientByIdEvent({required this.patientId});
}
