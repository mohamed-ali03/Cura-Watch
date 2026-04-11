import 'package:bloc/bloc.dart';
import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/errors/exception.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:meta/meta.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DioConsumer dioConsumer;

  DoctorBloc({required this.dioConsumer}) : super(DoctorInitial()) {
    on<DoctorEvent>((event, emit) {});
    on<GetAllDoctorsEvent>(_getDoctors);
    on<GetDoctorEvent>(_getDoctor);
    on<GetCurrentDoctorEvent>(_getCurrentDoctor);
    on<EditDoctorEvent>(_editDoctorInfo);
    on<GetAssignedPatient>(_getAssignedPatient);
  }

  Future<void> _getDoctors(
    GetAllDoctorsEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetAllDoctorLoading());
      final response = await dioConsumer.get(EndPoints.getDoctors);

      emit(
        GetAllDoctorLoaded(
          doctors: (response["data"] as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList(),
        ),
      );
    } on ServerException catch (e) {
      emit(GetAllDoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(GetAllDoctorError(message: e.toString()));
    }
  }

  Future<void> _getDoctor(
    GetDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetCurrentDoctorLoading());
      final response = await dioConsumer.get(
        '${EndPoints.getDoctor}/${event.id}',
      );

      emit(GetCurrentDoctorLoaded(doctor: Doctor.fromJson(response["data"])));
    } on ServerException catch (e) {
      emit(GetCurrentDoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(GetCurrentDoctorError(message: e.toString()));
    }
  }

  Future<void> _getCurrentDoctor(
    GetCurrentDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetCurrentDoctorLoading());
      final response = await dioConsumer.get(EndPoints.currentDoctorProfile);

      emit(GetCurrentDoctorLoaded(doctor: Doctor.fromJson(response["data"])));
    } on ServerException catch (e) {
      emit(GetCurrentDoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(GetCurrentDoctorError(message: e.toString()));
    }
  }

  Future<void> _editDoctorInfo(
    EditDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(EditDoctorInfoLoading());
      final response = await dioConsumer.get(
        EndPoints.currentDoctorProfile,
        data: {
          if (event.fullName != null) 'full_name': event.fullName,
          if (event.email != null) 'email': event.email,
          if (event.gender != null) 'gender': event.gender,
          if (event.phoneNumber != null) 'phone_number': event.phoneNumber,
          if (event.availableHours != null)
            'available_hours': event.availableHours,
        },
      );
      emit(EditDoctorInfoLoaded(doctor: Doctor.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(EditDoctorInfoError(message: e.errorModel.message));
    } catch (e) {
      emit(EditDoctorInfoError(message: e.toString()));
    }
  }

  Future<void> _getAssignedPatient(
    GetAssignedPatient event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetAssignedPatientLoading());
      final response = await dioConsumer.get(EndPoints.getAssignedPatient);
      emit(
        GetAssignedPatientLoaded(
          patients: (response['data'] as List<dynamic>)
              .map((patient) => Patient.fromJson(patient))
              .toList(),
        ),
      );
    } on ServerException catch (e) {
      emit(GetAssignedPatientError(message: e.errorModel.message));
    } catch (e) {
      emit(GetAssignedPatientError(message: e.toString()));
    }
  }
}
