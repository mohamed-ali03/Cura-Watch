import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<CacheHelper>(CacheHelper());
  getIt.registerSingleton<SizeConfig>(SizeConfig());
}
