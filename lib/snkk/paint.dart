import 'package:flutter/material.dart';

class PaintImage extends CustomPainter {

  final List<List<int>> snakePosition;

  PaintImage({@required this.snakePosition});

  int row = 10;
  int column = 20;
  int index = -1;

  // Offset offset = Offset(-8, 8);
  double dx = -10;
  double dy = -10;

  void paint(Canvas canvas, Size size) {
    Paint _paintSelColor = new Paint()
      // ..blendMode = BlendMode.overlay
      // ..color = Colors.black12
      // ..style = PaintingStyle.stroke
      ..style = PaintingStyle.fill;

    Paint _paintFogging = new Paint()
      // ..color = Colors.black87
      ..style = PaintingStyle.fill;
    // for (var item in snakePosition) {



      for (var i = 0; i < row; i++) {
        index += 1;
        // if(snakePosition[index][1] == i){
        //   _paintSelColor.color = Colors.black87;
        // } else {
        //   _paintSelColor.color = Colors.black12;
        // }
      dx += 19.3;
      dy = -10;
      for (var j = 0; j < column; j++) {
        if(snakePosition[0][0] == i && snakePosition[0][1] == j){
          _paintSelColor.color = Colors.black87;
        } else {
          _paintSelColor.color = Colors.black12;
        }
        dy += 19.3;
        canvas.drawRect(
            Rect.fromCenter(center: Offset(dx, dy), width: 10, height: 10),
            _paintSelColor);
      }
    }
    // }
    
  }

  @override
  bool shouldRepaint(PaintImage oldDelegate) => true;
}
