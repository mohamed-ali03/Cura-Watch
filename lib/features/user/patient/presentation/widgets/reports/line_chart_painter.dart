// ─── Line Chart Painter ─────────────────────────────────────────────────────

import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final List<Reading> readings;
  final ReportPeriod period;

  const LineChartPainter({required this.readings, required this.period});

  static const _gridColor = Color(0xFFEEF0F3);
  static const _lineColor = Color(0xFFE05252);
  static const _labelColor = Color(0xFF9AA3AF);
  static const _axisColor = Color(0xFFD0D5DD);

  static const _leftPad = 36.0;
  static const _rightPad = 10.0;
  static const _topPad = 10.0;
  static const _bottomPad = 28.0;

  static const _labelStyle = TextStyle(fontSize: 10, color: _labelColor);

  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void paint(Canvas canvas, Size size) {
    if (readings.isEmpty) return;

    final chartW = size.width - _leftPad - _rightPad;
    final chartH = size.height - _topPad - _bottomPad;

    final sorted = [...readings]..sort((a, b) => a.date.compareTo(b.date));
    final values = sorted.map((r) => r.value).toList();

    final minV = (values.reduce((a, b) => a < b ? a : b) - 5).clamp(0.0, 200.0);
    final maxV = values.reduce((a, b) => a > b ? a : b) + 5;
    final valueRange = maxV - minV;

    final minDate = sorted.first.date;
    final totalDays = sorted.last.date.difference(minDate).inDays + 1;

    // Helpers
    double xOf(Reading r) {
      final days = r.date.difference(minDate).inDays;
      return _leftPad + (days / totalDays) * chartW;
    }

    double yOf(double value) {
      final t = (value - minV) / valueRange;
      return _topPad + chartH * (1 - t);
    }

    // Grid + Y labels
    final gridPaint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final t = i / 4;
      final y = _topPad + chartH * (1 - t);
      canvas.drawLine(
        Offset(_leftPad, y),
        Offset(_leftPad + chartW, y),
        gridPaint,
      );
      final label = (minV + valueRange * t).round().toString();
      _drawText(canvas, label, Offset(0, y - 6), 32);
    }

    // X axis
    canvas.drawLine(
      Offset(_leftPad, _topPad + chartH),
      Offset(_leftPad + chartW, _topPad + chartH),
      Paint()
        ..color = _axisColor
        ..strokeWidth = 1,
    );

    // X labels
    _drawXLabels(canvas, sorted, chartW, chartH);

    // Line path
    final linePaint = Paint()
      ..color = _lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < sorted.length; i++) {
      final x = xOf(sorted[i]);
      final y = yOf(sorted[i].value);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, linePaint);

    // Dots
    final dotFill = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final r in sorted) {
      final offset = Offset(xOf(r), yOf(r.value));
      canvas.drawCircle(offset, 4, dotBorder);
      canvas.drawCircle(offset, 3, dotFill);
    }
  }

  void _drawXLabels(
    Canvas canvas,
    List<Reading> sorted,
    double chartW,
    double chartH,
  ) {
    final yPos = _topPad + chartH + 8;
    final totalDays = sorted.last.date.difference(sorted.first.date).inDays + 1;

    double xFor(int index) =>
        _leftPad +
        (sorted[index].date.difference(sorted.first.date).inDays / totalDays) *
            chartW;

    switch (period) {
      case ReportPeriod.day:
        for (int h = 0; h <= 24; h += 2) {
          _drawText(
            canvas,
            '${h}h',
            Offset(_leftPad + (h / 24) * chartW - 12, yPos),
            30,
          );
        }
      case ReportPeriod.week:
        for (int i = 0; i < sorted.length; i++) {
          final day = _weekDays[sorted[i].date.weekday % 7];
          _drawText(canvas, day, Offset(xFor(i) - 12, yPos), 30);
        }
      case ReportPeriod.month:
        for (int i = 0; i < sorted.length; i += 3) {
          _drawText(
            canvas,
            '${sorted[i].date.day}',
            Offset(xFor(i) - 6, yPos),
            20,
          );
        }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(LineChartPainter old) =>
      old.readings != readings || old.period != period;
}
