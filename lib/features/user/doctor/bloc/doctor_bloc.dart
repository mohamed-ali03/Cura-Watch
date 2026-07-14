import 'package:bloc/bloc.dart';
import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/errors/exception.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:cura_watch/features/user/shared/model/vital_info.dart';
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
    on<DoctorVitalReportEvent>(_getVitalInfo);
    on<MarkNotificationReadEvent>(_markNotificationRead);
    on<GetPatientByIdEvent>(_getPatientById);
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
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }

  Future<void> _getDoctor(
    GetDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetDoctorLoading());
      final response = await dioConsumer.get(
        '${EndPoints.getDoctor}/${event.id}',
      );

      emit(GetDoctorLoaded(doctor: Doctor.fromJson(response["data"])));
    } on ServerException catch (e) {
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
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
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }

  Future<void> _editDoctorInfo(
    EditDoctorEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(EditDoctorInfoLoading());
      final response = await dioConsumer.patch(
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
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
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
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }

  Future<void> _getVitalInfo(
    DoctorVitalReportEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(DoctorVitalInfoListLoading());

      final Map<String, dynamic> response;

      if (event.date == null) {
        response = await dioConsumer.get(
          '${EndPoints.getAssignedPatient}/${event.patientId}/vitals-averages',
          queryParameters: {'range': event.range},
        );
      } else {
        if (event.range == 'week') {
          response = await dioConsumer.get(
            '${EndPoints.getAssignedPatient}/${event.patientId}/vitals-averages',
            queryParameters: {
              'week_start': () {
                final d = event.date!;
                final monday = d.subtract(Duration(days: d.weekday - 1));
                return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
              }(),
            },
          );
        } else if (event.range == 'month') {
          response = await dioConsumer.get(
            '${EndPoints.getAssignedPatient}/${event.patientId}/vitals-averages',
            queryParameters: {
              'month': event.date!.month,
              'year': event.date!.year,
            },
          );
        } else {
          response = await dioConsumer.get(
            '${EndPoints.getAssignedPatient}/${event.patientId}/vitals-averages',
            queryParameters: {
              'date':
                  '${event.date!.year}-${event.date!.month}-${event.date!.day}',
            },
          );
        }
      }

      List<VitalInfo> vitalInfoList = (response['data'] as List<dynamic>)
          .map((e) => VitalInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(DoctorVitalInfoListLoaded(vitalInfoList: vitalInfoList));
    } on ServerException catch (e) {
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }

  Future<void> _markNotificationRead(
    MarkNotificationReadEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(MarkNotificationReadLoading());
      await dioConsumer.patch('${EndPoints.doctorsNotifications}/${event.id}');
      emit(MarkNotificationReadLoaded());
    } on ServerException catch (e) {
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }

  Future<void> _getPatientById(
    GetPatientByIdEvent event,
    Emitter<DoctorState> emit,
  ) async {
    try {
      emit(GetPatientByIdLoading());
      final response = await dioConsumer.get(
        '${EndPoints.getAssignedPatient}/${event.patientId}',
      );
      final patientData = response['patient'];
      if (patientData == null) {
        throw Exception('Patient data not found in server response');
      }
      final patient = Patient.fromJson(patientData);
      final List<VitalInfo> vitalsHistory =
          (response['vitalsHistory'] as List<dynamic>?)
              ?.map((e) => VitalInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      emit(
        GetPatientByIdLoaded(patient: patient, vitalsHistory: vitalsHistory),
      );
    } on ServerException catch (e) {
      emit(DoctorError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }
}
