import 'doctor.dart';

class Patient {
  String fullName;
  String email;
  String password;
  String phoneNumber;
  String gender;
  double weight;
  double height;
  DateTime dateOfBirth;
  String bloodType;
  String assignedDoctorId;
  List<String> chronicDiseases;
  List<String> allergies;
  Map<String, dynamic> medications;
  Map<String, dynamic> emergencyContact;
  Doctor? doctor;

  Patient({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
    required this.weight,
    required this.height,
    required this.dateOfBirth,
    required this.bloodType,
    required this.assignedDoctorId,
    required this.chronicDiseases,
    required this.allergies,
    required this.medications,
    required this.emergencyContact,
    this.doctor,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    fullName: json["full_name"] ?? '',
    email: json["email"] ?? '',
    password: json["password"] ?? '',
    phoneNumber: json["phone_number"] ?? '',
    gender: json["gender"] ?? '',
    weight: json["weight"]?.toDouble() ?? 0.0,
    height: json["height"]?.toDouble() ?? 0.0,
    dateOfBirth: DateTime.parse(json["date_of_birth"] ?? '1900-01-01'),
    bloodType: json["blood_type"] ?? '',
    assignedDoctorId: json["assigned_doctor_id"] ?? '',
    chronicDiseases: List<String>.from(
      json["chronic_diseases"]?.map((x) => x) ?? [],
    ),
    allergies: List<String>.from(json["allergies"]?.map((x) => x) ?? []),
    medications: json["medications"] ?? {},
    emergencyContact: json["emergency_contact"] ?? {},
    doctor: json["doctors"] != null ? Doctor.fromJson(json["doctors"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "password": password,
    "phone_number": phoneNumber,
    "gender": gender,
    "weight": weight,
    "height": height,
    "date_of_birth":
        "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "blood_type": bloodType,
    "assigned_doctor_id": assignedDoctorId,
    "chronic_diseases": List<dynamic>.from(chronicDiseases.map((x) => x)),
    "allergies": List<dynamic>.from(allergies.map((x) => x)),
    "medications": medications,
    "emergency_contact": emergencyContact,
  };
}
