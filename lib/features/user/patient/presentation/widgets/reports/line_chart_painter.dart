// ─── Line Chart Painter ─────────────────────────────────────────────────────

import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final List<Reading> readings;
  final ReportPeriod period;
  final bool isBloodPressure;

  const LineChartPainter({
    required this.readings,
    required this.period,
    this.isBloodPressure = false,
  });

  static const _gridColor = Color(0xFFEEF0F3);
  static const _lineColor = Color(0xFFE05252);
  static const _systolicColor = Color(0xFFE05252);
  static const _diastolicColor = Color(0xFF4A6FA5);
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

    // Line paths
    if (isBloodPressure) {
      final systolicReadings = readings
          .where((r) => r.label == 'Systolic')
          .toList();
      final diastolicReadings = readings
          .where((r) => r.label == 'Diastolic')
          .toList();

      // Draw systolic line
      if (systolicReadings.isNotEmpty) {
        final systolicPath = Path();
        for (int i = 0; i < systolicReadings.length; i++) {
          final x = xOf(systolicReadings[i]);
          final y = yOf(systolicReadings[i].value);
          i == 0 ? systolicPath.moveTo(x, y) : systolicPath.lineTo(x, y);
        }

        final systolicPaint = Paint()
          ..color = _systolicColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        canvas.drawPath(systolicPath, systolicPaint);
      }

      // Draw diastolic line
      if (diastolicReadings.isNotEmpty) {
        final diastolicPath = Path();
        for (int i = 0; i < diastolicReadings.length; i++) {
          final x = xOf(diastolicReadings[i]);
          final y = yOf(diastolicReadings[i].value);
          i == 0 ? diastolicPath.moveTo(x, y) : diastolicPath.lineTo(x, y);
        }

        final diastolicPaint = Paint()
          ..color = _diastolicColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        canvas.drawPath(diastolicPath, diastolicPaint);
      }
    } else {
      // Single line for other vitals
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
    }

    // Dots
    if (isBloodPressure) {
      final systolicReadings = readings
          .where((r) => r.label == 'Systolic')
          .toList();
      final diastolicReadings = readings
          .where((r) => r.label == 'Diastolic')
          .toList();

      // Systolic dots
      final systolicDotFill = Paint()
        ..color = _systolicColor
        ..style = PaintingStyle.fill;
      final systolicDotBorder = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      for (final r in systolicReadings) {
        final offset = Offset(xOf(r), yOf(r.value));
        canvas.drawCircle(offset, 4, systolicDotBorder);
        canvas.drawCircle(offset, 3, systolicDotFill);
      }

      // Diastolic dots
      final diastolicDotFill = Paint()
        ..color = _diastolicColor
        ..style = PaintingStyle.fill;
      final diastolicDotBorder = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      for (final r in diastolicReadings) {
        final offset = Offset(xOf(r), yOf(r.value));
        canvas.drawCircle(offset, 4, diastolicDotBorder);
        canvas.drawCircle(offset, 3, diastolicDotFill);
      }
    } else {
      // Single color dots for other vitals
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

    // Legend for blood pressure
    if (isBloodPressure) {
      _drawBloodPressureLegend(canvas, chartW, chartH);
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

  void _drawBloodPressureLegend(Canvas canvas, double chartW, double chartH) {
    const legendY = 5.0;
    const legendItemWidth = 80.0;
    const legendSpacing = 10.0;

    // Systolic legend
    final systolicLegendX =
        _leftPad + (chartW - (2 * legendItemWidth + legendSpacing)) / 2;
    _drawLegendItem(
      canvas,
      systolicLegendX,
      legendY,
      _systolicColor,
      'Systolic',
    );

    // Diastolic legend
    final diastolicLegendX = systolicLegendX + legendItemWidth + legendSpacing;
    _drawLegendItem(
      canvas,
      diastolicLegendX,
      legendY,
      _diastolicColor,
      'Diastolic',
    );
  }

  void _drawLegendItem(
    Canvas canvas,
    double x,
    double y,
    Color color,
    String label,
  ) {
    // Draw colored line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(x, y + 6), Offset(x + 20, y + 6), linePaint);

    // Draw label
    _drawText(canvas, label, Offset(x + 25, y), 50);
  }

  @override
  bool shouldRepaint(LineChartPainter old) =>
      old.readings != readings ||
      old.period != period ||
      old.isBloodPressure != isBloodPressure;
}
