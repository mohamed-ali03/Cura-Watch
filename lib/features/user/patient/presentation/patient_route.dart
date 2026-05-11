import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/user_on_boarding.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientRoute extends StatefulWidget {
  const PatientRoute({super.key});

  @override
  State<PatientRoute> createState() => _PatientRouteState();
}

class _PatientRouteState extends State<PatientRoute> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(GetPatientInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      buildWhen: (prev, curr) {
        // Only re-route when transitioning from loading/initial to success/error
        return curr is PatientLoaded ||
            curr is PatientLoadingError ||
            (curr is PatientLoaded && prev is PatientLoading);
      },
      builder: (context, state) {
        if (state is PatientLoading || state is PatientInitial) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is PatientLoaded) {
          if (state.patient.assignedDoctorId.isEmpty) {
            return UserOnBoarding();
          }
          return PatientHome(patient: state.patient);
        } else if (state is PatientLoadingError) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    getIt<CacheHelper>().removeData(key: APIKeys.token);
                    Navigator.pushNamed(context, '/');
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(
              child: Text('Error loading patient data ${state.message}'),
            ),
          );
        }
        return Scaffold(
          body: Center(child: Text('Error loading patient data')),
        );
      },
    );
  }
}
