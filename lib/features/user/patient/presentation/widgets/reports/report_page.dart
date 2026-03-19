// health_report_page.dart

import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/line_chart_painter.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/period_toggle.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/vital_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Models ────────────────────────────────────────────────────────────────

enum ReportPeriod {
  day('daily'),
  week('weekly'),
  month('monthly');

  const ReportPeriod(this.apiRange);
  final String apiRange;
}

class Reading {
  final DateTime date;
  final double value;

  const Reading({required this.date, required this.value});
}
// ─── Page ──────────────────────────────────────────────────────────────────

class HealthReportPage extends StatefulWidget {
  final VitalConfig config;

  const HealthReportPage({super.key, required this.config});

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
    context.read<PatientBloc>().add(VitalReportEvent(range: period.apiRange));
  }

  List<Reading> _extractReadings(List<dynamic> vitalInfoList) {
    return vitalInfoList
        .map((vitalInfo) {
          final raw = switch (widget.config.name) {
            'Blood Pressure' => vitalInfo.pressure,
            'Temperature' => vitalInfo.temperature,
            'Heart Rate' => vitalInfo.heartRate,
            'Steps' => vitalInfo.steps,
            'Oxygen' => vitalInfo.oxygen,
            'Glucose' => vitalInfo.glucose,
            _ => null,
          };

          if (raw == null) return null;

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
            BlocBuilder<PatientBloc, PatientState>(
              // Rebuild on any list state change
              buildWhen: (_, current) =>
                  current is VitalInfoListLoading ||
                  current is VitalInfoListLoaded,
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
                  return _ReportBody(
                    config: widget.config,
                    readings: readings,
                    period: _period,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
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

  String get _dateRange {
    if (readings.isEmpty) return '';
    final sorted = [...readings]..sort((a, b) => a.date.compareTo(b.date));
    return '${_fmtDate(sorted.last.date)} - ${_fmtDate(sorted.first.date)}';
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
            child: ValueListenableBuilder(
              valueListenable: period,
              builder: (_, p, _) => CustomPaint(
                painter: LineChartPainter(readings: readings, period: p),
                size: Size.infinite,
              ),
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
            child: Row(
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
              ...readings.map((r) => _readingRow(r)),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _statItem(String value, String label) => Expanded(
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

  Widget _statDivider() => Container(width: 1, height: 40, color: _divider);

  Widget _readingRow(Reading r) => Column(
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
              _shortDate(r.date),
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
                    text: r.value.toInt().toString(),
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
