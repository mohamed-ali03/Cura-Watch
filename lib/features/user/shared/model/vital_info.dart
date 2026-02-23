class VitalInfo {
  String? id;
  String patientId;
  int heartRate;
  int oxygen;
  int steps;
  Locations locations;
  double temperature;
  int glucose;
  String pressure;
  DateTime readingDate;

  VitalInfo({
    this.id,
    required this.patientId,
    required this.heartRate,
    required this.oxygen,
    required this.steps,
    required this.locations,
    required this.temperature,
    required this.glucose,
    required this.pressure,
    required this.readingDate,
  });

  factory VitalInfo.fromJson(Map<String, dynamic> json) => VitalInfo(
    id: json["id"],
    patientId: json["patient_id"],
    heartRate: json["heart_rate"],
    oxygen: json["oxygen"],
    steps: json["steps"],
    locations: Locations.fromJson(json["locations"]),
    temperature: json["temperature"]?.toDouble(),
    glucose: json["glucose"],
    pressure: json["pressure"],
    readingDate: DateTime.parse(json["reading_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patient_id": patientId,
    "heart_rate": heartRate,
    "oxygen": oxygen,
    "steps": steps,
    "locations": locations.toJson(),
    "temperature": temperature,
    "glucose": glucose,
    "pressure": pressure,
    "reading_date": readingDate.toIso8601String(),
  };
}

class Locations {
  String indoor;
  String outdoor;

  Locations({required this.indoor, required this.outdoor});

  factory Locations.fromJson(Map<String, dynamic> json) =>
      Locations(indoor: json["indoor"], outdoor: json["outdoor"]);

  Map<String, dynamic> toJson() => {"indoor": indoor, "outdoor": outdoor};
}
