import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ReportPeriod { day, week, month }

class Reading {
  final DateTime date;
  final double value;
  const Reading({required this.date, required this.value});
}

class HealthReportWidget extends StatefulWidget {
  final String title;
  final IconData icon;

  const HealthReportWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<HealthReportWidget> createState() => _HealthReportWidgetState();
}

class _HealthReportWidgetState extends State<HealthReportWidget> {
  // ── Colors & config ──────────────────────────
  static const Color _accentRed = Color(0xFFE05252);
  static const Color _accentBlue = Color(0xFF4A6FA5);
  static const Color _toggleBg = Color(0xFFF0F4F8);
  static const Color _selectedBg = Color(0xFF4A6FA5);
  static const Color _divider = Color(0xFFEEF0F3);
  static const Color _labelGrey = Color(0xFF9AA3AF);
  static const Color _textDark = Color(0xFF1E2632);

  @override
  void initState() {
    super.initState();
    // Initialize data based on title
    data = reportData.firstWhere((e) => e['name'] == widget.title);
  }

  final ValueNotifier<ReportPeriod> _period = ValueNotifier(ReportPeriod.month);

  Map<String, dynamic> data = {};

  String get _normalLabel =>
      '${data['normalRangeMin'].toInt()} – ${data['normalRangeMax'].toInt()}';

  double get _avg {
    final r = data['readings'];
    if (r.isEmpty) return 0;
    return r.map((e) => e.value).reduce((a, b) => a + b) / r.length;
  }

  double get _max {
    final r = data['readings'];
    if (r.isEmpty) return 0;
    return r.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  double get _min {
    final r = data['readings'];
    if (r.isEmpty) return 0;
    return r.map((e) => e.value).reduce((a, b) => a < b ? a : b);
  }

  // ── Date range label ──────────────────────────
  String get _dateRange {
    final r = data['readings'];
    if (r.isEmpty) return '';
    final start = _fmtDate(r.first.date);
    final end = _fmtDate(r.last.date);
    return '$end - $start';
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

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(widget.title, style: headerTextStyle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildToggle(), _buildReport(), const SizedBox(height: 8)],
        ),
      ),
    );
  }

  // ── Week / Month toggle ───────────────────────
  Widget _buildToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getIt<SizeConfig>().blockWidth * 4,
        vertical: getIt<SizeConfig>().blockHight * 1,
      ),
      child: Container(
        height: getIt<SizeConfig>().blockHight * 5,
        decoration: BoxDecoration(
          color: _toggleBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ValueListenableBuilder(
          valueListenable: _period,
          builder: (context, value, child) => Row(
            children: [
              _toggleBtn(ReportPeriod.day, 'Daily'),
              _toggleBtn(ReportPeriod.week, 'Week'),
              _toggleBtn(ReportPeriod.month, 'Month'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleBtn(ReportPeriod p, String label) {
    final selected = _period.value == p;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<PatientBloc>().add(
            VitalReportEvent(
              range: switch (p) {
                ReportPeriod.day => 'daliy',
                ReportPeriod.week => 'weekly',
                ReportPeriod.month => 'monthly',
              },
            ),
          );
          _period.value = p;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected ? _selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _selectedBg.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : _labelGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReport() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is VitalInfoListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VitalInfoListLoaded) {
          data['readings'].clear();
          switch (_period.value) {
            case ReportPeriod.day:
              data['readings'].addAll(dayReadings);
              break;
            case ReportPeriod.week:
              data['readings'].addAll(weekReadings);
              break;
            case ReportPeriod.month:
              data['readings'].addAll(monthReadings);
              break;
          }
        }
        return Column(
          children: [
            _buildDateRange(),
            _buildChart(),
            _buildStats(),
            _buildReadingsList(),
          ],
        );
      },
    );
  }

  // ── Date range label ──────────────────────────
  Widget _buildDateRange() {
    return Padding(
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
    );
  }

  // ── Line chart ────────────────────────────────
  Widget _buildChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _LineChartPainter(
            readings: data['readings'],
            period: _period.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  // ── Stats row ─────────────────────────────────
  Widget _buildStats() {
    return Padding(
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

  // ── Readings list ─────────────────────────────
  Widget _buildReadingsList() {
    final readings = data['readings'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(widget.icon, color: _textDark, size: 22),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.title} Readings',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  Text(
                    'Normal: $_normalLabel',
                    style: const TextStyle(fontSize: 11, color: _labelGrey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // List items
          ...readings.map((r) => _readingRow(r)),
        ],
      ),
    );
  }

  Widget _readingRow(Reading r) {
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
                      text: ' ${data['unit']}',
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
}

// ─────────────────────────────────────────────
//  Custom Line Chart Painter
// ─────────────────────────────────────────────

class _LineChartPainter extends CustomPainter {
  final List<Reading> readings;
  final ReportPeriod period;

  _LineChartPainter({required this.readings, required this.period});

  static const Color _gridColor = Color(0xFFEEF0F3);
  static const Color _lineColor = Color(0xFFE05252);
  static const Color _labelColor = Color(0xFF9AA3AF);
  static const Color _axisColor = Color(0xFFD0D5DD);

  @override
  void paint(Canvas canvas, Size size) {
    if (readings.isEmpty) return;

    const double leftPad = 36;
    const double rightPad = 10;
    const double topPad = 10;
    const double bottomPad = 28;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    // ── Y range ───────────────────────────────────
    final values = readings.map((r) => r.value).toList();
    final minV = (values.reduce((a, b) => a < b ? a : b) - 5)
        .clamp(0, 200)
        .toDouble();
    final maxV = (values.reduce((a, b) => a > b ? a : b) + 5).toDouble();

    // ── Grid lines + Y labels ─────────────────────
    final gridPaint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(fontSize: 10, color: _labelColor);

    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final t = i / gridCount;
      final y = topPad + chartH * (1 - t);
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartW, y),
        gridPaint,
      );
      final vLabel = (minV + (maxV - minV) * t).round().toString();
      _drawText(canvas, vLabel, Offset(0, y - 6), labelStyle, 32);
    }

    // ── X axis ────────────────────────────────────
    final axisPaint = Paint()
      ..color = _axisColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(leftPad, topPad + chartH),
      Offset(leftPad + chartW, topPad + chartH),
      axisPaint,
    );

    // ── X labels ──────────────────────────────────
    if (period == ReportPeriod.day) {
      for (int i = 0; i < 12; i++) {
        final x = leftPad + (i / 11) * chartW;
        final label = i.toString();
        _drawText(
          canvas,
          label,
          Offset(x - 12, topPad + chartH + 8),
          labelStyle,
          30,
        );
      }
    } else if (period == ReportPeriod.week) {
      const weekLabels = ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];
      for (int i = 0; i < 7; i++) {
        final x = leftPad + (i / 6) * chartW;
        final label = weekLabels[i % weekLabels.length];
        _drawText(
          canvas,
          label,
          Offset(x - 12, topPad + chartH + 8),
          labelStyle,
          30,
        );
      }
    } else if (period == ReportPeriod.month) {
      // Month: show every ~3 days: 1,4,7,10,13,16,19,22,25,28,31
      const monthMarks = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31];
      for (final m in monthMarks) {
        final idx = m - 1;
        if (idx >= readings.length) continue;
        final x = leftPad + (idx / (readings.length - 1)) * chartW;
        _drawText(
          canvas,
          m.toString(),
          Offset(x - 6, topPad + chartH + 8),
          labelStyle,
          20,
        );
      }
    }

    // ── Line path ─────────────────────────────────
    final linePaint = Paint()
      ..color = _lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < readings.length; i++) {
      final t = (readings[i].value - minV) / (maxV - minV);
      final x = leftPad + (i / (readings.length - 1)) * chartW;
      final y = topPad + chartH * (1 - t);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, linePaint);

    // ── Dots ──────────────────────────────────────
    final dotPaint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < readings.length; i++) {
      final t = (readings[i].value - minV) / (maxV - minV);
      final x = leftPad + (i / (readings.length - 1)) * chartW;
      final y = topPad + chartH * (1 - t);
      canvas.drawCircle(Offset(x, y), 4, dotBorder);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
    double maxWidth,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.readings != readings || old.period != ReportPeriod.week;
}
