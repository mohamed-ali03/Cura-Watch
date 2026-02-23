import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/errors/error_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionError:
      throw ServerException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.unknown:
      throw ServerException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad Request
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 400,
            }),
          );
        case 401: // Unauthorized
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 401,
            }),
          );
        case 403: // Forbidden
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 403,
            }),
          );
        case 404: // Not Found
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 404,
            }),
          );
        case 409: // Conflict
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 409,
            }),
          );
        case 422: // Unprocessable Entity
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 422,
            }),
          );
        case 504: // Gateway Timeout
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: 504,
            }),
          );
        default:
          throw ServerException(
            ErrorModel.fromJson({
              APIKeys.message:
                  e.response!.data['message'] ?? e.response!.data['error'],
              APIKeys.status: e.response!.statusCode!,
            }),
          );
      }
  }
}
