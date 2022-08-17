import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final int xCount, yCount;
  BackgroundPainter(this.xCount, this.yCount) : super();

  @override
  void paint(Canvas canvas, Size size) {
    double canvasHeight = size.height;
    double canvasWidth = size.width;
    double gridHeight = canvasHeight / yCount;
    double gridWidth = canvasWidth / xCount;

    Paint thickBorder = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint thinBorder = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    Paint strokeBrush = Paint()
      ..color = Color.fromARGB(255, 255, 150, 142)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    canvas.drawCircle(Offset(15, 15), 50, strokeBrush);
    canvas.drawLine(Offset(0, 0), Offset(360, 360), strokeBrush);
    Path path = Path()..moveTo(10, 20);
    path.lineTo(20, 10);
    canvas.drawPath(path, strokeBrush);

    Path outerLine = Path()..lineTo(0, canvasHeight);

    Path path2 = Path()..moveTo(0, 0);
    path2.lineTo(gridHeight, gridWidth);
    canvas.drawPath(path2, thickBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate != this;
}
