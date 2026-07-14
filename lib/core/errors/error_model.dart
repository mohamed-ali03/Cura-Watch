import 'package:cura_watch/core/api/end_points.dart';

class ErrorModel {
  final int status;
  final String message;
  ErrorModel({required this.message, required this.status});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json[APIKeys.message],
      status: json[APIKeys.status] ?? 0,
    );
  }
}
