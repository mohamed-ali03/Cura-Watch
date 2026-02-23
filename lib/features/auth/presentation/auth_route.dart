import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:cura_watch/features/auth/presentation/signin_screen.dart';
import 'package:cura_watch/features/auth/presentation/signup_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthRoute extends StatefulWidget {
  const AuthRoute({super.key});

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  bool goToSignInScreen = true;

  void toggle() {
    setState(() {
      goToSignInScreen = !goToSignInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBlocBloc>(
      create: (context) => AuthBlocBloc(DioConsumer(Dio())),
      child: goToSignInScreen
          ? SignInScreen(onTap: toggle)
          : SignUpScreen(onTap: toggle),
    );
  }
}
