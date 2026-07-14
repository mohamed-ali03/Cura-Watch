part of 'patient_bloc.dart';

@immutable
sealed class PatientEvent {}

// Patient Info
class GetPatientInfoEvent extends PatientEvent {}

class EditPatientInfoEvent extends PatientEvent {
  final String? fullName;
  final String? password;
  final String? phoneNumber;
  final String? gender;
  final double? weight;
  final double? height;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final String? assignedDoctorId;
  final List<String>? chronicDiseases;
  final List<String>? allergies;
  final Map<String, dynamic>? medications;
  final List<Map<String, dynamic>>? emergencyContact;

  EditPatientInfoEvent({
    this.fullName,
    this.password,
    this.phoneNumber,
    this.gender,
    this.weight,
    this.height,
    this.dateOfBirth,
    this.bloodType,
    this.assignedDoctorId,
    this.chronicDiseases,
    this.allergies,
    this.medications,
    this.emergencyContact,
  });
}

// Vital Info
class EditVitalInfoEvent extends PatientEvent {
  final String id;
  final int? heartRate;
  final int? oxygen;
  final int? steps;
  final double? temperature;
  final int? glucose;
  final String? pressure;

  EditVitalInfoEvent({
    required this.id,
    this.heartRate,
    this.oxygen,
    this.steps,
    this.temperature,
    this.glucose,
    this.pressure,
  });
}

class SendVitalInfoEvent extends PatientEvent {
  final int heartRate;
  final int oxygen;
  final int steps;
  final double temperature;
  final int glucose;
  final String pressure;
  final Locations? locations;

  SendVitalInfoEvent({
    this.heartRate = 0,
    this.oxygen = 0,
    this.steps = 0,
    this.temperature = 0,
    this.glucose = 0,
    this.pressure = '',
    this.locations,
  });
}

class GetVitalInfoEvent extends PatientEvent {}

class DeleteVitalInfoEvent extends PatientEvent {
  final String id;

  DeleteVitalInfoEvent({required this.id});
}

// Vital Reports
class VitalReportEvent extends PatientEvent {
  final String? range;
  final DateTime? date;

  VitalReportEvent({this.range, this.date});
}
