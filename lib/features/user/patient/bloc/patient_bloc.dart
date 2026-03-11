import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/errors/exception.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:cura_watch/features/user/shared/model/vital_info.dart';
import 'package:meta/meta.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final DioConsumer dioConsumer;

  StreamSubscription? _pollVitalInfo;
  StreamSubscription? _pollVitalList;

  void startPollingVitalInfo() {
    _pollVitalInfo = Stream.periodic(const Duration(seconds: 30)).listen((_) {
      add(GetVitalInfoEvent());
    });
  }

  void stopPollingVitalInfo() {
    _pollVitalInfo?.cancel();
  }

  void startPollingVitalList(String range) {
    _pollVitalList = Stream.periodic(const Duration(seconds: 30)).listen((_) {
      add(VitalReportEvent(range: range));
    });
  }

  void stopPollingVitalList() {
    _pollVitalList?.cancel();
  }

  @override
  Future<void> close() {
    _pollVitalInfo?.cancel();
    _pollVitalList?.cancel();
    return super.close();
  }

  PatientBloc({required this.dioConsumer}) : super(PatientInitial()) {
    on<GetPatientInfoEvent>(_getPatientInfo);
    on<EditPatientInfoEvent>(_editPatientInfo);
    on<GetDoctors>(_getDoctors);
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
      emit(PatientLoading());
      final response = await dioConsumer.get(EndPoints.getPatientInfo);
      emit(PatientLoaded(patient: Patient.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(PatientLoadingError(message: e.errorModel.message));
    } catch (e) {
      emit(PatientLoadingError(message: e.toString()));
    }
  }

  Future<void> _editPatientInfo(
    EditPatientInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(PatientLoading());
      final response = await dioConsumer.patch(
        EndPoints.getPatientInfo,
        data: {
          if (event.fullName != null && event.fullName!.isNotEmpty)
            APIKeys.fullName: event.fullName,
          if (event.password != null && event.password!.isNotEmpty)
            APIKeys.password: event.password,
          if (event.phoneNumber != null && event.phoneNumber!.isNotEmpty)
            APIKeys.phoneNumber: event.phoneNumber,
          if (event.gender != null && event.gender!.isNotEmpty)
            APIKeys.gender: event.gender,
          if (event.weight != null && event.weight! > 0)
            APIKeys.weight: event.weight,
          if (event.height != null && event.height! > 0)
            APIKeys.height: event.height,
          if (event.dateOfBirth != null)
            APIKeys.dateOfBirth: event.dateOfBirth?.toIso8601String(),
          if (event.bloodType != null && event.bloodType!.isNotEmpty)
            APIKeys.bloodType: event.bloodType,
          if (event.assignedDoctorId != null &&
              event.assignedDoctorId!.isNotEmpty)
            APIKeys.assignedDoctorId: event.assignedDoctorId,
          if (event.chronicDiseases != null &&
              event.chronicDiseases!.isNotEmpty)
            APIKeys.chronicDiseases: event.chronicDiseases,
          if (event.allergies != null && event.allergies!.isNotEmpty)
            APIKeys.allergies: event.allergies,
          if (event.medications != null && event.medications!.isNotEmpty)
            APIKeys.medications: event.medications,
          if (event.emergencyContact != null &&
              event.emergencyContact!.isNotEmpty)
            APIKeys.emergencyContact: event.emergencyContact,
        },
      );
      emit(PatientLoaded(patient: Patient.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(PatientLoadingError(message: e.errorModel.message));
    } catch (e) {
      emit(PatientLoadingError(message: e.toString()));
    }
  }

  Future<void> _getDoctors(GetDoctors event, Emitter<PatientState> emit) async {
    try {
      emit(DoctorsLoading());
      final response = await dioConsumer.get(EndPoints.getDoctors);

      emit(
        DoctorsLoaded(
          doctors: (response["data"] as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList(),
        ),
      );
    } on ServerException catch (e) {
      emit(DoctorsLoadingError(message: e.errorModel.message));
    } catch (e) {
      emit(DoctorsLoadingError(message: e.toString()));
    }
  }

  Future<void> _sendVitalInfo(
    SendVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(VitalInfoLoading());
      final response = await dioConsumer.post(
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
      emit(VitalInfoLoaded(vitalInfo: VitalInfo.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(VitalInfoError(message: e.errorModel.message));
    } catch (e) {
      emit(VitalInfoError(message: e.toString()));
    }
  }

  Future<void> _editVitalInfo(
    EditVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(VitalInfoLoading());
      final response = await dioConsumer.patch(
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
      emit(VitalInfoLoaded(vitalInfo: VitalInfo.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(VitalInfoError(message: e.errorModel.message));
    } catch (e) {
      emit(VitalInfoError(message: e.toString()));
    }
  }

  Future<void> _getVitalInfo(
    GetVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(VitalInfoLoading());
      final response = await dioConsumer.get(EndPoints.getVitalInfo);
      emit(VitalInfoLoaded(vitalInfo: VitalInfo.fromJson(response['data'][0])));
    } on ServerException catch (e) {
      emit(VitalInfoError(message: e.errorModel.message));
    } catch (e) {
      emit(VitalInfoError(message: e.toString()));
    }
  }

  Future<void> _deleteVitalInfo(
    DeleteVitalInfoEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(VitalInfoLoading());
      final response = await dioConsumer.delete(
        '${EndPoints.sendVitalInfo}/${event.id}',
      );
      emit(VitalInfoLoaded(vitalInfo: VitalInfo.fromJson(response['data'])));
    } on ServerException catch (e) {
      emit(VitalInfoError(message: e.errorModel.message));
    } catch (e) {
      emit(VitalInfoError(message: e.toString()));
    }
  }

  Future<void> _vitalReport(
    VitalReportEvent event,
    Emitter<PatientState> emit,
  ) async {
    try {
      emit(VitalInfoListLoading());
      final response = await dioConsumer.get(
        EndPoints.vitalReports,
        queryParameters: {'range': event.range},
      );
      List<VitalInfo> vitalInfoList = (response['data'] as List<dynamic>)
          .map((e) => VitalInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(VitalInfoListLoaded(vitalInfoList: vitalInfoList));
    } on ServerException catch (e) {
      emit(VitalInfoListError(message: e.errorModel.message));
    } catch (e) {
      emit(VitalInfoListError(message: e.toString()));
    }
  }
}
