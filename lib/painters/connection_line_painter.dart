import 'package:flutter/material.dart';

class ConnectionLinePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final double progress;

  ConnectionLinePainter({
    required this.startPoint,
    required this.endPoint,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset currentEndPoint = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * progress,
      startPoint.dy + (endPoint.dy - startPoint.dy) * progress,
    );

    canvas.drawLine(startPoint, currentEndPoint, paint);
    
    if (progress > 0) {
      final Paint dotPaint = Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.fill;
      canvas.drawCircle(startPoint, 5.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionLinePainter oldDelegate) {
    return oldDelegate.startPoint != startPoint ||
        oldDelegate.endPoint != endPoint ||
        oldDelegate.progress != progress;
  }
}
