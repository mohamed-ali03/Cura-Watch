import 'package:cura_watch/core/api/end_points.dart';

class ErrorModel {
  final int status;
  final String message;
  ErrorModel(this.message, this.status);

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(json[APIKeys.status], json[APIKeys.message]);
  }
}
