import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/auth/presentation/forget_password_screen.dart';
import 'package:cura_watch/features/auth/presentation/reset_password_screen.dart';
import 'package:cura_watch/features/auth/presentation/signin_screen.dart';
import 'package:cura_watch/features/auth/presentation/signup_screen.dart';
import 'package:cura_watch/features/auth/presentation/verification_screen.dart';
import 'package:flutter/material.dart';

class AuthRoute extends StatefulWidget {
  const AuthRoute({super.key});

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  AuthRouteType currentRoute = AuthRouteType.signIn;

  void route(AuthRouteType nextRoute) {
    setState(() {
      currentRoute = nextRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (currentRoute) {
      AuthRouteType.signIn => SignInScreen(onTap: route),
      AuthRouteType.signUp => SignUpScreen(onTap: route),
      AuthRouteType.forgetPassword => ForgetPasswordScreen(onTap: route),
      AuthRouteType.verification => VerificationScreen(onTap: route),
      AuthRouteType.resetPassword => ResetPasswordScreen(onTap: route),
    };
  }
}
