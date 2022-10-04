import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

class HeaderPaintWaves extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    final path = Path();
    path.lineTo(0, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.65,
        size.width * 0.5, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.52, size.width, size.height * 0.55);

    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HeaderPaintCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    final path = Path();
    path.lineTo(0, size.height * 0.50);
    path.quadraticBezierTo(
        size.width * 0.50, size.height, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HeaderPaintDiagonal extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.75);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
