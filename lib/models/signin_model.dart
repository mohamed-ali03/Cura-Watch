class SigninModel {
  String message;
  String token;
  Data data;

  SigninModel({required this.message, required this.token, required this.data});

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
    message: json["message"],
    token: json["token"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String fullName;
  String email;
  String role;

  Data({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
  };
}
