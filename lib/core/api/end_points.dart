class EndPoints {
  static const String baseUrl = 'https://cura-watch.onrender.com/api/v1/';
  static const String signIn = 'auth/login';
  static const String signUpPatient = 'auth/register/patient';
  static const String signUpDoctor = 'auth/register/doctor';
  static const String getMe = 'auth/getME';

  static const String getPatientInfo = 'patients/profile';

  static const String sendVitalInfo = 'patients/vitals';
  static const String getVitalInfo = 'patients/vitals-history';

  static const String vitalReports = 'patients/vitals-reports';
}

class APIKeys {
  static const String status = 'status';
  static const String message = 'message';
  static const String email = 'email';
  static const String password = 'password';
  static const String phoneNumber = 'phone_number';
  static const String role = 'role';
  static const String id = 'id';
  static const String fullName = 'full_name';
  static const String token = 'token';
  static const String data = 'data';
  static const String gender = 'gender';
  static const String weight = 'weight';
  static const String height = 'height';
  static const String dateOfBirth = 'date_of_birth';
  static const String bloodType = 'blood_type';
  static const String assignedDoctorId = 'assigned_doctor_id';
  static const String chronicDiseases = 'chronic_diseases';
  static const String allergies = 'allergies';
  static const String medications = 'medications';
  static const String emergencyContact = 'emergency_contact';
  static const String patientId = 'patient_id';
  static const String heartRate = 'heart_rate';
  static const String oxygen = 'oxygen';
  static const String steps = 'steps';
  static const String temperature = 'temperature';
  static const String glucose = 'glucose';
  static const String pressure = 'pressure';
  static const String locations = 'locations';
  static const String readingDate = 'reading_date';
}
