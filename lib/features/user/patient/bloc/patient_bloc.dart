import 'package:bloc/bloc.dart';
import 'package:cura_watch/core/api/api_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/errors/exception.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/features/user/patient/data/model/patient.dart';
import 'package:cura_watch/features/user/shared/model/vital_info.dart';
import 'package:meta/meta.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  PatientBloc() : super(PatientInitial()) {
    on<GetPatientInfoEvent>(_getPatientInfo);
    on<EditPatientInfoEvent>(_editPatientInfo);
    on<SendVitalInfoEvent>(_sendVitalInfo);
    on<EditVitalInfoEvent>(_editVitalInfo);
    on<GetVitalInfoEvent>(_getVitalInfo);
    on<DeleteVitalInfoEvent>(_deleteVitalInfo);
    on<VitalReportEvent>(_vitalReport);
  }

  Future<void> _getPatientInfo(
    GetPatientInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().get(EndPoints.getPatientInfo);
      emit(
        PatientStateSuccess(
          patient: Patient.fromJson(response['data']),
          message: response['message'],
        ),
      );
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _editPatientInfo(
    EditPatientInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().patch(
        EndPoints.getPatientInfo,
        data: {
          if (event.fullName != null) APIKeys.fullName: event.fullName,
          if (event.password != null) APIKeys.password: event.password,
          if (event.phoneNumber != null) APIKeys.phoneNumber: event.phoneNumber,
          if (event.gender != null) APIKeys.gender: event.gender,
          if (event.weight != null) APIKeys.weight: event.weight,
          if (event.height != null) APIKeys.height: event.height,
          if (event.dateOfBirth != null) APIKeys.dateOfBirth: event.dateOfBirth,
          if (event.bloodType != null) APIKeys.bloodType: event.bloodType,
          if (event.assignedDoctorId != null)
            APIKeys.assignedDoctorId: event.assignedDoctorId,
          if (event.chronicDiseases != null)
            APIKeys.chronicDiseases: event.chronicDiseases,
          if (event.allergies != null) APIKeys.allergies: event.allergies,
          if (event.medications != null) APIKeys.medications: event.medications,
          if (event.emergencyContact != null)
            APIKeys.emergencyContact: event.emergencyContact,
        },
      );
      emit(
        PatientStateSuccess(
          patient: Patient.fromJson(response['data']),
          message: response['message'],
        ),
      );
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _sendVitalInfo(
    SendVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().post(
        EndPoints.sendVitalInfo,
        data: {
          APIKeys.heartRate: event.heartRate,
          APIKeys.oxygen: event.oxygen,
          APIKeys.steps: event.steps,
          APIKeys.temperature: event.temperature,
          APIKeys.glucose: event.glucose,
          APIKeys.pressure: event.pressure,
          APIKeys.locations: event.locations?.toJson(),
          APIKeys.readingDate: DateTime.now().toIso8601String(),
        },
      );
      emit(
        PatientStateSuccess(
          vitalInfo: VitalInfo.fromJson(response['data']),
          message: response['message'],
        ),
      );
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _editVitalInfo(
    EditVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().patch(
        '${EndPoints.sendVitalInfo}/${event.id}',
        data: {
          if (event.heartRate != null) APIKeys.heartRate: event.heartRate,
          if (event.oxygen != null) APIKeys.oxygen: event.oxygen,
          if (event.steps != null) APIKeys.steps: event.steps,
          if (event.temperature != null) APIKeys.temperature: event.temperature,
          if (event.glucose != null) APIKeys.glucose: event.glucose,
          if (event.pressure != null) APIKeys.pressure: event.pressure,
        },
      );
      emit(
        PatientStateSuccess(
          vitalInfo: VitalInfo.fromJson(response['data']),
          message: response['message'],
        ),
      );
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _getVitalInfo(
    GetVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().delete(
        EndPoints.getVitalInfo,
      );
      List<VitalInfo> vitalInfoList = response['data']
          .map((e) => VitalInfo.fromJson(e))
          .toList();
      emit(PatientStateSuccess(vitalInfoList: vitalInfoList));
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _deleteVitalInfo(
    DeleteVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().delete(
        '${EndPoints.sendVitalInfo}/${event.id}',
      );
      emit(PatientStateSuccess(message: response['message']));
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }

  Future<void> _vitalReport(
    VitalReportEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientStateLoading());
      final response = await getIt<ApiConsumer>().delete(
        EndPoints.vitalReports,
        queryParameters: {'range': event.range},
      );
      List<VitalInfo> vitalInfoList = response['data']
          .map((e) => VitalInfo.fromJson(e))
          .toList();
      emit(
        PatientStateSuccess(
          vitalInfoList: vitalInfoList,
          message: response['range'],
        ),
      );
    } on ServerException catch (e) {
      emit(PatientStateError(e.errorModel.message));
    } catch (e) {
      emit(PatientStateError(e.toString()));
    }
  }
}
