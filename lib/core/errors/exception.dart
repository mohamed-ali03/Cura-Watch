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
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 401: // Unauthorized
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 403: // Forbidden
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 404: // Not Found
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 409: // Conflict
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 422: // Unprocessable Entity
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        case 504: // Gateway Timeout
          throw ServerException(ErrorModel.fromJson(e.response!.data));
        default:
          throw ServerException(ErrorModel.fromJson(e.response!.data));
      }
  }
}
