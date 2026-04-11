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
  final String id;

  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final Map<String, dynamic>? availableHours;
  EditDoctorEvent({
    required this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.availableHours,
  });
}

final class GetAssignedPatient extends DoctorEvent {}
