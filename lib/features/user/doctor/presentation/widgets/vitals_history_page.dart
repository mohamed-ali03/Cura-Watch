import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/shared/model/vital_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VitalsHistoryPage extends StatelessWidget {
  final String patientName;
  final String patientId;

  const VitalsHistoryPage({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History: $patientName', style: headerTextStyle),
        centerTitle: true,
      ),
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is GetPatientByIdLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<VitalInfo> history = [];
          if (state is GetPatientByIdLoaded) {
            history = state.vitalsHistory;
          }

          if (history.isEmpty) {
            return const Center(child: Text('No historical data found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final reading = history[index];
              return _buildReadingCard(reading);
            },
          );
        },
      ),
    );
  }

  Widget _buildReadingCard(VitalInfo reading) {
    final date = reading.readingDate;
    final formattedDate = date != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(date.toLocal())
        : 'Unknown Date';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const Icon(Icons.history, size: 16, color: Colors.grey),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _buildMetric(
                  Icons.favorite,
                  'HR',
                  '${reading.heartRate ?? '-'}',
                  Colors.red,
                ),
                _buildMetric(
                  Icons.water_drop,
                  'SpO2',
                  '${reading.oxygen ?? '-'}%',
                  Colors.blue,
                ),
                _buildMetric(
                  Icons.speed,
                  'BP',
                  reading.pressure ?? '-',
                  Colors.orange,
                ),
                _buildMetric(
                  Icons.bloodtype,
                  'Glu',
                  '${reading.glucose ?? '-'}',
                  Colors.purple,
                ),
                if (reading.temperature != null)
                  _buildMetric(
                    Icons.thermostat,
                    'Temp',
                    '${reading.temperature}°C',
                    Colors.teal,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
