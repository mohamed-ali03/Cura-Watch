part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthSignIn extends AuthBlocEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

class AuthSignUp extends AuthBlocEvent {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmedPassword;
  final String role;

  AuthSignUp({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmedPassword,
    required this.role,
  });
}

class AuthLogOut extends AuthBlocEvent {}

class AuthGetMe extends AuthBlocEvent {}
