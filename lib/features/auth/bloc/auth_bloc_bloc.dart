import 'package:bloc/bloc.dart';
import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/errors/exception.dart';
import 'package:cura_watch/core/functions.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/features/auth/data/models/signin_model.dart';
import 'package:meta/meta.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final DioConsumer dioConsumer;

  AuthBloc(this.dioConsumer) : super(AuthBlocInitial()) {
    on<AuthSignIn>(_onSignIn);
    on<AuthSignUp>(_onSingUp);
    on<AuthLogOut>(_onLogOut);
    on<AuthGetMe>(_onGetMe);
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthBlocState> emit) async {
    try {
      emit(AuthBlocLoading());
      String hashpassword = hashPassword(event.password);
      final response = await dioConsumer.post(
        EndPoints.signIn,
        data: {APIKeys.email: event.email, APIKeys.password: hashpassword},
      );
      await getIt<CacheHelper>().saveUserData(
        token: response[APIKeys.token],
        id: response[APIKeys.data][APIKeys.id],
        role: response[APIKeys.data][APIKeys.role],
        fullName: response[APIKeys.data][APIKeys.fullName],
      );
      emit(AuthBlocSuccess(user: User.fromJson(response[APIKeys.data])));
    } on ServerException catch (e) {
      emit(AuthBlocError(message: e.errorModel.message));
    } catch (e) {
      emit(AuthBlocError(message: e.toString()));
    }
  }

  Future<void> _onSingUp(AuthSignUp event, Emitter<AuthBlocState> emit) async {
    try {
      emit(AuthBlocLoading());
      if (event.password != event.confirmedPassword) {
        emit(AuthBlocError(message: 'Passwords do not match'));
        return;
      }

      String hashedPassword = hashPassword(event.password);
      final response = await dioConsumer.post(
        event.role == 'Doctor'
            ? EndPoints.signUpDoctor
            : EndPoints.signUpPatient,
        data: {
          APIKeys.fullName: event.fullName,
          APIKeys.email: event.email,
          APIKeys.phoneNumber: event.phoneNumber,
          APIKeys.password: hashedPassword,
        },
      );
      emit(AuthBlocSuccess(message: response[APIKeys.message]));
    } on ServerException catch (e) {
      emit(AuthBlocError(message: e.errorModel.message));
    } catch (e) {
      emit(AuthBlocError(message: e.toString()));
    }
  }

  Future<void> _onLogOut(AuthLogOut event, Emitter<AuthBlocState> emit) async {
    try {
      emit(AuthBlocLoading());
      await getIt<CacheHelper>().removeData(key: APIKeys.token);
      await getIt<CacheHelper>().removeData(key: APIKeys.id);
      emit(AuthBlocSuccess());
    } catch (e) {
      emit(AuthBlocError(message: e.toString()));
    }
  }

  Future<void> _onGetMe(AuthGetMe event, Emitter<AuthBlocState> emit) async {
    try {
      emit(AuthBlocLoading());
      final response = await dioConsumer.get(EndPoints.getMe);
      emit(AuthBlocSuccess(user: response[APIKeys.data]));
    } on ServerException catch (e) {
      emit(AuthBlocError(message: e.errorModel.message));
    } catch (e) {
      emit(AuthBlocError(message: e.toString()));
    }
  }
}
