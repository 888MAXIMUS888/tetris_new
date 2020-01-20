import 'package:flutter/material.dart';

class PaintImage3 extends CustomPainter {
  int row = 10;
  int column = 20;

  // Offset offset = Offset(-8, 8);
  double dx = -10;
  double dy = -10;

  void paint(Canvas canvas, Size size) {
    Paint _paintSelColor = new Paint()
      // ..blendMode = BlendMode.overlay
      ..color = Color(0xff9ead86)
      // ..style = PaintingStyle.stroke
      ..style = PaintingStyle.fill;

    Paint _paintFogging = new Paint()
      // ..color = Colors.black87
      ..style = PaintingStyle.fill;
    for (var i = 0; i < row; i++) {
      dx += 19.3;
      dy = -10;
      for (var i = 0; i < column; i++) {
        dy += 19.3;
        canvas.drawRect(
            Rect.fromCenter(center: Offset(dx, dy), width: 13, height: 13),
            _paintSelColor);
      }
    }
  }

  @override
  bool shouldRepaint(PaintImage3 oldDelegate) => true;
}
