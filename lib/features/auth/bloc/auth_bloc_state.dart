part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {
  final String? message;

  const AuthBlocState({this.message});
}

final class AuthBlocInitial extends AuthBlocState {
  const AuthBlocInitial() : super();
}

final class AuthBlocLoading extends AuthBlocState {
  const AuthBlocLoading() : super();
}

final class AuthBlocSuccess extends AuthBlocState {
  final User? user;

  const AuthBlocSuccess({this.user, super.message});
}

final class AuthBlocError extends AuthBlocState {
  const AuthBlocError({required String message}) : super(message: message);
}
