import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:cura_watch/features/auth/presentation/auth_route.dart';
import 'package:cura_watch/features/auth/presentation/on_boarding.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/doctor/presentation/doctor_home.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/patient_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static DioConsumer dioConsumer = DioConsumer(Dio());
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        final bool? isNotFirstTime = getIt<CacheHelper>().getData(
          key: 'isNotFirstTime',
        );

        if (isNotFirstTime == true) {
          final String? token = getIt<CacheHelper>().getData(
            key: APIKeys.token,
          );

          if (token != null) {
            final String? role = getIt<CacheHelper>().getData(
              key: APIKeys.role,
            );
            if (role == 'doctor') {
              return MaterialPageRoute(
                builder: (_) => BlocProvider<DoctorBloc>(
                  create: (context) => DoctorBloc(dioConsumer: dioConsumer),
                  child: const DoctorHome(),
                ),
              );
            } else if (role == 'patient') {
              return MaterialPageRoute(
                builder: (_) => BlocProvider<PatientBloc>(
                  create: (context) =>
                      PatientBloc(dioConsumer: getIt<DioConsumer>()),
                  child: const PatientRoute(),
                ),
              );
            }
            return _onErrorRoute(routeError: 'Invalid role: $role');
          }
          return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(dioConsumer),
              child: const AuthRoute(),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(dioConsumer),
            child: const AuthRoute(),
          ),
        );
      case '/user':
        final String? role = getIt<CacheHelper>().getData(key: APIKeys.role);
        if (role == 'doctor') {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<DoctorBloc>(
              create: (context) => DoctorBloc(dioConsumer: dioConsumer),
              child: const DoctorHome(),
            ),
          );
        } else if (role == 'patient') {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<PatientBloc>(
              create: (context) => PatientBloc(dioConsumer: dioConsumer),
              child: const PatientRoute(),
            ),
          );
        }
        return _onErrorRoute(routeError: 'Invalid role: $role');
      default:
        return _onErrorRoute(routeError: 'Invalid route: ${settings.name}');
    }
  }

  static Route<dynamic> _onErrorRoute({required String routeError}) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Routing Error')),
        body: Center(child: Text(routeError)),
      ),
    );
  }
}
