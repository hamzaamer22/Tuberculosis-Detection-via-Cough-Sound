import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // Blue background
    Path bluePath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.85, 0, size.height * 0.65)
      ..close();

    paint.color = Colors.blue;
    canvas.drawPath(bluePath, paint);

    // Black bottom section
    Path blackPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.85, size.width, size.height * 0.55)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    paint.color = Colors.black;
    canvas.drawPath(blackPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
