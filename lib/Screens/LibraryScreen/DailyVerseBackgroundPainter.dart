import 'package:flutter/material.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';

class DailyVerseBackgroundPainter extends CustomPainter {
  Color color;
  BuildContext context;

  DailyVerseBackgroundPainter({required this.color, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var path = Path();
    final double startPoint = size.width * 0.2;
    const double corner = 10;
    const double rheight = 155;
    path.moveTo(startPoint, rheight - corner);
    path.lineTo(startPoint, corner);
    path.moveTo(startPoint, corner);
    path.lineTo(startPoint + corner, corner);
    path.moveTo(startPoint + corner, corner);
    path.lineTo(startPoint + corner, 0);
    path.moveTo(startPoint + corner, 0);
    path.lineTo(startPoint + ScreenConfig.screenWidth - 60, 0);
    path.moveTo(startPoint + ScreenConfig.screenWidth - 60, 0);
    path.lineTo(startPoint + ScreenConfig.screenWidth - 60, corner);
    path.lineTo(startPoint + ScreenConfig.screenWidth - corner - 40, corner);
    path.lineTo(
        startPoint + ScreenConfig.screenWidth - corner - 40, rheight - corner);
    path.moveTo(
        startPoint + ScreenConfig.screenWidth - corner - 40, rheight - corner);
    path.lineTo(
        startPoint + ScreenConfig.screenWidth - corner - 50, rheight - corner);
    path.moveTo(startPoint + ScreenConfig.screenWidth - 60, rheight - corner);
    path.lineTo(startPoint + ScreenConfig.screenWidth - 60, rheight);
    path.moveTo(startPoint + ScreenConfig.screenWidth - 60, rheight);
    path.lineTo(startPoint + corner, rheight);
    path.moveTo(startPoint + corner, rheight);
    path.lineTo(startPoint + corner, rheight - corner);
    path.moveTo(startPoint + corner, rheight - corner);
    path.lineTo(startPoint, rheight - corner);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
