class Doctor {
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String gender;
  Map<String, dynamic> availableHours;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.availableHours,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["id"] ?? '',
    fullName: json["full_name"] ?? '',
    email: json["email"] ?? '',
    phoneNumber: json["phone_number"] ?? '',
    gender: json["gender"] ?? '',
    availableHours: json["available_hours"] ?? {},
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "gender": gender,
    "available_hours": availableHours,
  };
}
