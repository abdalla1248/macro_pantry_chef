import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A donut chart showing macro distribution (Protein, Carbs, Fat).
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.proteinRatio,
    required this.carbsRatio,
    required this.fatRatio,
    required this.centerText,
    required this.centerLabel,
    this.size = 192,
    this.strokeWidth = 12,
  });

  final double proteinRatio;
  final double carbsRatio;
  final double fatRatio;
  final String centerText;
  final String centerLabel;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chartSize = size.r;

    return SizedBox(
      width: chartSize,
      height: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(chartSize, chartSize),
            painter: _DonutPainter(
              proteinRatio: proteinRatio,
              carbsRatio: carbsRatio,
              fatRatio: fatRatio,
              proteinColor: scheme.secondaryContainer,
              carbsColor: scheme.primaryContainer,
              fatColor: const Color(0xFFB0F1CC),
              trackColor: scheme.surfaceContainerHighest,
              strokeWidth: strokeWidth.r,
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: scheme.primary,
                      fontSize: 32.sp,
                      height: 1,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                centerLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.proteinRatio,
    required this.carbsRatio,
    required this.fatRatio,
    required this.proteinColor,
    required this.carbsColor,
    required this.fatColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double proteinRatio;
  final double carbsRatio;
  final double fatRatio;
  final Color proteinColor;
  final Color carbsColor;
  final Color fatColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2; // 12 o'clock

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Segments
    final segments = [
      (carbsRatio, carbsColor),
      (proteinRatio, proteinColor),
      (fatRatio, fatColor),
    ];

    double currentAngle = startAngle;
    for (final (ratio, color) in segments) {
      if (ratio <= 0) continue;
      final sweep = ratio * 2 * math.pi;
      final segmentPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweep,
        false,
        segmentPaint,
      );
      currentAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      proteinRatio != oldDelegate.proteinRatio ||
      carbsRatio != oldDelegate.carbsRatio ||
      fatRatio != oldDelegate.fatRatio;
}
