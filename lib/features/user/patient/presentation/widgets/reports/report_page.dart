// health_report_page.dart

import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/line_chart_painter.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/period_toggle.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/vital_config.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Models ────────────────────────────────────────────────────────────────

enum ReportPeriod {
  day('day'),
  week('week'),
  month('month');

  const ReportPeriod(this.apiRange);
  final String apiRange;
}

class Reading {
  final DateTime date;
  final double value;
  final String? label; // For blood pressure: 'Systolic' or 'Diastolic'

  const Reading({required this.date, required this.value, this.label});
}
// ─── Page ──────────────────────────────────────────────────────────────────

class HealthReportPage extends StatefulWidget {
  final VitalConfig config;
  final Patient? patient;
  const HealthReportPage({super.key, required this.config, this.patient});

  @override
  State<HealthReportPage> createState() => _HealthReportPageState();
}

class _HealthReportPageState extends State<HealthReportPage> {
  final _period = ValueNotifier(ReportPeriod.month);

  @override
  void initState() {
    super.initState();
    _fetchReport(ReportPeriod.month);
  }

  @override
  void dispose() {
    _period.dispose();
    super.dispose();
  }

  void _fetchReport(ReportPeriod period) {
    if (widget.patient != null) {
      context.read<DoctorBloc>().add(
        DoctorVitalReportEvent(
          range: period.apiRange,
          patientId: widget.patient!.id,
        ),
      );
    } else {
      context.read<PatientBloc>().add(VitalReportEvent(range: period.apiRange));
    }
  }

  List<Reading> _extractReadings(List<dynamic> vitalInfoList) {
    if (widget.config.name == 'Blood Pressure') {
      return vitalInfoList
          .map((vitalInfo) {
            final raw = vitalInfo.pressure;
            if (raw == null) return null;

            // Handle blood pressure format like '80/120'
            if (raw is String && raw.contains('/')) {
              final parts = raw.split('/');
              if (parts.length == 2) {
                final systolic = double.tryParse(parts[0]);
                final diastolic = double.tryParse(parts[1]);
                if (systolic != null && diastolic != null) {
                  return [
                    Reading(
                      date: vitalInfo.readingDate,
                      value: systolic,
                      label: 'Systolic',
                    ),
                    Reading(
                      date: vitalInfo.readingDate,
                      value: diastolic,
                      label: 'Diastolic',
                    ),
                  ];
                }
              }
            }

            // Fallback to single value parsing
            final value = switch (raw) {
              String s => double.tryParse(s) ?? 0.0,
              int i => i.toDouble(),
              double d => d,
              _ => 0.0,
            };
            return [Reading(date: vitalInfo.readingDate, value: value)];
          })
          .where((readings) => readings != null)
          .expand((readings) => readings!)
          .toList();
    }

    // Handle other vitals (non-blood pressure)
    return vitalInfoList
        .map((vitalInfo) {
          final raw = switch (widget.config.name) {
            'Temperature' => vitalInfo.temperature,
            'Heart Rate' => vitalInfo.heartRate,
            'Steps' => vitalInfo.steps,
            'Oxygen' => vitalInfo.oxygen,
            'Glucose' => vitalInfo.glucose,
            _ => null,
          };

          if (raw == null) {
            return null;
          }

          final value = switch (raw) {
            String s => double.tryParse(s) ?? 0.0,
            int i => i.toDouble(),
            double d => d,
            _ => 0.0,
          };

          return Reading(date: vitalInfo.readingDate, value: value);
        })
        .whereType<Reading>()
        .toList();
  }

  // pick date
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now, // default 18 years old
      firstDate: DateTime(1900), // minimum DOB
      lastDate: now, // can't pick future date
    );

    if (picked != null && context.mounted) {
      if (widget.patient != null) {
        context.read<DoctorBloc>().add(
          DoctorVitalReportEvent(
            date: picked,
            range: _period.value.apiRange,
            patientId: widget.patient!.id,
          ),
        );
      } else {
        context.read<PatientBloc>().add(
          VitalReportEvent(date: picked, range: _period.value.apiRange),
        );
      }
    }
  }

  // ── Build ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(widget.config.name, style: headerTextStyle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month, color: Color(mainColor)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PeriodToggle(
              period: _period,
              onChanged: (p) {
                _period.value = p;
                _fetchReport(p);
              },
            ),
            _blocBuild(),
          ],
        ),
      ),
    );
  }

  Widget _blocBuild() {
    if (widget.patient != null) {
      return BlocBuilder<DoctorBloc, DoctorState>(
        buildWhen: (_, current) =>
            current is DoctorVitalInfoListLoading ||
            current is DoctorVitalInfoListLoaded,
        builder: (context, state) {
          if (state is DoctorVitalInfoListLoading) {
            return Padding(
              padding: EdgeInsets.only(
                top: getIt<SizeConfig>().blockHight * 35,
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is DoctorVitalInfoListLoaded) {
            final readings = _extractReadings(state.vitalInfoList);
            readings.sort((a, b) => b.date.compareTo(a.date));
            return _ReportBody(
              config: widget.config,
              readings: readings,
              period: _period,
            );
          }

          return const SizedBox.shrink();
        },
      );
    } else {
      return BlocBuilder<PatientBloc, PatientState>(
        buildWhen: (_, current) =>
            current is VitalInfoListLoading || current is VitalInfoListLoaded,
        builder: (context, state) {
          if (state is VitalInfoListLoading) {
            return Padding(
              padding: EdgeInsets.only(
                top: getIt<SizeConfig>().blockHight * 35,
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is VitalInfoListLoaded) {
            final readings = _extractReadings(state.vitalInfoList);
            readings.sort((a, b) => b.date.compareTo(a.date));
            return _ReportBody(
              config: widget.config,
              readings: readings,
              period: _period,
            );
          }

          return const SizedBox.shrink();
        },
      );
    }
  }
}

// ─── Report Body ───────────────────────────────────────────────────────────

class _ReportBody extends StatelessWidget {
  final VitalConfig config;
  final List<Reading> readings;
  final ValueNotifier<ReportPeriod> period;

  const _ReportBody({
    required this.config,
    required this.readings,
    required this.period,
  });

  static const _accentRed = Color(0xFFE05252);
  static const _accentBlue = Color(0xFF4A6FA5);
  static const _divider = Color(0xFFEEF0F3);
  static const _labelGrey = Color(0xFF9AA3AF);
  static const _textDark = Color(0xFF1E2632);

  double get _avg => readings.isEmpty
      ? 0
      : readings.map((r) => r.value).reduce((a, b) => a + b) / readings.length;

  double get _max => readings.isEmpty
      ? 0
      : readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);

  double get _min => readings.isEmpty
      ? 0
      : readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);

  // Blood pressure specific stats
  List<Reading> get _systolicReadings =>
      readings.where((r) => r.label == 'Systolic').toList();
  List<Reading> get _diastolicReadings =>
      readings.where((r) => r.label == 'Diastolic').toList();

  Map<String, dynamic> get pressure => {
    'Systolic': _systolicReadings,
    'Diastolic': _diastolicReadings,
  };

  double get _systolicAvg => _systolicReadings.isEmpty
      ? 0
      : _systolicReadings.map((r) => r.value).reduce((a, b) => a + b) /
            _systolicReadings.length;

  double get _diastolicAvg => _diastolicReadings.isEmpty
      ? 0
      : _diastolicReadings.map((r) => r.value).reduce((a, b) => a + b) /
            _diastolicReadings.length;

  double get _systolicMax => _systolicReadings.isEmpty
      ? 0
      : _systolicReadings.map((r) => r.value).reduce((a, b) => a > b ? a : b);

  double get _diastolicMax => _diastolicReadings.isEmpty
      ? 0
      : _diastolicReadings.map((r) => r.value).reduce((a, b) => a > b ? a : b);

  double get _systolicMin => _systolicReadings.isEmpty
      ? 0
      : _systolicReadings.map((r) => r.value).reduce((a, b) => a < b ? a : b);

  double get _diastolicMin => _diastolicReadings.isEmpty
      ? 0
      : _diastolicReadings.map((r) => r.value).reduce((a, b) => a < b ? a : b);

  String get _dateRange {
    if (readings.isEmpty) return '';
    final sorted = [...readings]..sort((a, b) => a.date.compareTo(b.date));
    return '${_fmtDate(sorted.first.date)} - ${_fmtDate(sorted.last.date)}';
  }

  String _fmtDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _shortDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (period.value == ReportPeriod.day) {
      return '${d.hour.toString().padLeft(2, '0')}h';
    }
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date range
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Center(
            child: Text(
              _dateRange,
              style: const TextStyle(
                fontSize: 12,
                color: _accentBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 140,
            child: CustomPaint(
              painter: LineChartPainter(
                readings: readings,
                period: period.value,
                isBloodPressure: config.name == 'Blood Pressure',
                isDay: period.value == ReportPeriod.day,
              ),
              size: Size.infinite,
            ),
          ),
        ),

        // Stats
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _divider, width: 1.5),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: config.name == 'Blood Pressure'
                ? Row(
                    children: [
                      _statItem(
                        '${_systolicAvg.round()}/${_diastolicAvg.round()}',
                        'AVG',
                      ),
                      _statDivider(),
                      _statItem(
                        '${_systolicMax.round()}/${_diastolicMax.round()}',
                        'MAX',
                      ),
                      _statDivider(),
                      _statItem(
                        '${_systolicMin.round()}/${_diastolicMin.round()}',
                        'MIN',
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _statItem(_avg.round().toString(), 'AVG'),
                      _statDivider(),
                      _statItem(_max.round().toString(), 'MAX'),
                      _statDivider(),
                      _statItem(_min.round().toString(), 'MIN'),
                    ],
                  ),
          ),
        ),

        // Readings list
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(config.icon, color: _textDark, size: 22),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${config.name} Readings',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      Text(
                        'Normal: ${config.normalRangeMin.toInt()} – ${config.normalRangeMax.toInt()}',
                        style: const TextStyle(fontSize: 11, color: _labelGrey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...config.name == 'Blood Pressure'
                  ? _pressureRows()
                  : readings.map(
                      (r) => _readingRow(r.date, r.value.toString()),
                    ),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: _accentRed,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _labelGrey,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() => Container(width: 1, height: 40, color: _divider);

  Widget _readingRow(DateTime date, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: _labelGrey,
              ),
              const SizedBox(width: 10),
              Text(
                _shortDate(date),
                style: const TextStyle(
                  fontSize: 14,
                  color: _textDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _accentRed,
                        letterSpacing: -0.4,
                      ),
                    ),
                    TextSpan(
                      text: ' ${config.unit}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _labelGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: _divider),
      ],
    );
  }

  List<Widget> _pressureRows() {
    // Group readings by date
    final Map<DateTime, Map<String, Reading>> groupedReadings = {};

    for (final reading in readings) {
      final date = DateTime(
        reading.date.year,
        reading.date.month,
        reading.date.day,
      );
      if (!groupedReadings.containsKey(date)) {
        groupedReadings[date] = {};
      }
      if (reading.label != null) {
        groupedReadings[date]![reading.label!] = reading;
      }
    }

    // Sort dates and create rows
    final sortedDates = groupedReadings.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      final readingsForDate = groupedReadings[date]!;
      final systolic = readingsForDate['Systolic'];
      final diastolic = readingsForDate['Diastolic'];

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: _labelGrey,
                ),
                const SizedBox(width: 10),
                Text(
                  _shortDate(date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: _textDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                if (systolic != null && diastolic != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: systolic.value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _accentRed,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const TextSpan(
                          text: '/',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _labelGrey,
                            letterSpacing: -0.4,
                          ),
                        ),
                        TextSpan(
                          text: diastolic.value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _accentBlue,
                            letterSpacing: -0.4,
                          ),
                        ),
                        TextSpan(
                          text: ' ${config.unit}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _labelGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (systolic != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: systolic.value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _accentRed,
                            letterSpacing: -0.4,
                          ),
                        ),
                        TextSpan(
                          text: ' ${config.unit}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _labelGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (diastolic != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: diastolic.value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _accentBlue,
                            letterSpacing: -0.4,
                          ),
                        ),
                        TextSpan(
                          text: ' ${config.unit}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _labelGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: _divider),
        ],
      );
    }).toList();
  }
}
