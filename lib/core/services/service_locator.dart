import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/realtim_service.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<CacheHelper>(CacheHelper());
  getIt.registerSingleton<SizeConfig>(SizeConfig());
  getIt.registerSingleton<DioConsumer>(DioConsumer(Dio()));
  getIt.registerLazySingleton<RealtimeService>(() => RealtimeService());
}
