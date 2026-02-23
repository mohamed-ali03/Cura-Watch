class SigninModel {
  String message;
  String token;
  User user;

  SigninModel({required this.message, required this.token, required this.user});

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
    message: json["message"],
    token: json["token"],
    user: User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "data": user.toJson(),
  };
}

class User {
  String id;
  String fullName;
  String email;
  String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
