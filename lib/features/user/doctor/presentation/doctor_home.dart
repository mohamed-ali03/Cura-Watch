import 'package:cura_watch/core/services/realtim_service.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/features/user/doctor/presentation/doctor_patients.dart';
import 'package:cura_watch/features/user/doctor/presentation/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int currentIndex = 0;

  List<Widget> pages = [DoctorPatients(), DoctorProfile()];

  @override
  void initState() {
    super.initState();
    _initRealtimeListener();
  }

  void _initRealtimeListener() {
    getIt<RealtimeService>().startListening(
      onNotification: (payload) {
        if (!mounted) return;

        // Secure Check: Only show alert if currently logged in as a doctor
        final String? role = getIt<CacheHelper>().getData(key: APIKeys.role);
        if (role != 'doctor') {
          getIt<RealtimeService>().stopListening();
          return;
        }

        final message = payload['message'] as String?;
        final id = payload['id'] as String?;
        final patientId = payload['patient_id'] as String?;
        if (message != null && id != null) {
          _showCriticalAlert(id: id, message: message, patientId: patientId);
        }
      },
    );
  }

  void _showCriticalAlert({
    required String id,
    required String message,
    String? patientId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<DoctorBloc>(),
          child: _AlertContent(
            alertId: id,
            message: message,
            patientId: patientId,
            onActionDone: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    getIt<RealtimeService>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 250),
                ),
              );
            }
          });
        }
        if (state is MarkNotificationReadLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alert acknowledged'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home, color: Colors.blue),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person, color: Colors.blue),
              label: 'Profile',
            ),
          ],
        ),
        body: Column(
          children: [
            Image.asset('assets/logo/curawatch.jpeg'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: pages[currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertContent extends StatelessWidget {
  final String alertId;
  final String message;
  final String? patientId;
  final VoidCallback onActionDone;

  const _AlertContent({
    required this.alertId,
    required this.message,
    this.patientId,
    required this.onActionDone,
  });

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
      title: Text('🚨 Critical Vital Alert', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is GetPatientByIdLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetPatientByIdLoaded) {
                  final patient = state.patient;
                  if (patient.emergencyContact.isEmpty) {
                    return const Text("No emergency contacts found.");
                  }
                  return Column(
                    children: [
                      const Text(
                        "Patient Emergency Contacts:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...patient.emergencyContact.map((contact) {
                        final name = contact['name'] ?? 'Unknown';
                        final phone = contact['number']?.toString() ?? '';
                        return ListTile(
                          title: Text(name),
                          subtitle: Text(phone),
                          trailing: IconButton(
                            icon: Icon(Icons.call, color: Colors.blue),
                            onPressed: () => _makeCall(phone),
                          ),
                        );
                      }),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.emergency, color: Colors.white),
                label: Text(
                  'CALL AMBULANCE (123)',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  context.read<DoctorBloc>().add(
                    MarkNotificationReadEvent(id: alertId),
                  );
                  await _makeCall('123');
                  if (context.mounted) {
                    onActionDone();
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            if (patientId != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.people, color: Colors.white),
                  label: Text(
                    'CALL RELATIVES',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    context.read<DoctorBloc>().add(
                      GetPatientByIdEvent(patientId: patientId!),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<DoctorBloc>().add(
                    MarkNotificationReadEvent(id: alertId),
                  );
                  if (context.mounted) {
                    onActionDone();
                  }
                },
                child: Text('ACKNOWLEDGE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
