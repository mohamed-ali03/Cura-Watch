import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/auth/presentation/auth_route.dart';
import 'package:cura_watch/features/auth/presentation/on_boarding.dart';
import 'package:cura_watch/features/user/home_screen.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/user_on_boarding.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<CacheHelper>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<SizeConfig>().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getIt<CacheHelper>().getData(key: 'isNotFirstTime') == true
          ? getIt<CacheHelper>().getData(key: APIKeys.token) != null
                ? UserOnBoarding()
                : AuthRoute()
          : OnBoarding(),
    );
  }
}
