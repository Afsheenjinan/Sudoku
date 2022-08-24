import 'dart:ui';

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

    Paint dottedLine = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

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

    Path dottedPath = Path()..moveTo(50, 100);
    path2.lineTo(gridHeight / 2, gridWidth / 2);
    canvas.drawPath(path2, dottedLine);

    canvas.drawLine(Offset(10, 20), Offset(240, 150), dottedLine);

    drawDashedLineTop(
      canvas,
      start: const Offset(0, 0),
      end: Offset(size.width / 9, 0),
      paint: dottedLine,
    );
    drawDashedLineLeft(
      canvas,
      start: const Offset(0, 0),
      end: Offset(0, size.height / 9),
      paint: dottedLine,
    );

    Path outline = Path()
      ..moveTo(0, 0)
      ..lineTo(canvasWidth, 0)
      ..lineTo(canvasWidth, canvasHeight)
      ..lineTo(0, canvasHeight)
      ..close();
    canvas.drawPath(outline, thickBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate != this;

  void drawDashedLineTop(Canvas canvas, {required Offset start, required Offset end, required Paint paint, int dashCount = 4}) {
    double width = (end - start).dx;
    double dx = width / (2 * dashCount);

    // print("---------------------------");

    for (double deltaX = dx / 2; deltaX < width; deltaX += 2 * dx) {
      // print("$deltaX, ${deltaX + dx}");
      double deltaY = start.dy + dx / 2;
      canvas.drawLine(Offset(deltaX, deltaY), Offset(deltaX + dx, end.dy + dx / 2), paint);
    }
  }

  void drawDashedLineLeft(Canvas canvas, {required Offset start, required Offset end, required Paint paint, int dashCount = 4}) {
    double height = (end - start).dy;
    double dy = height / (2 * dashCount);

    // print("---------------------------");

    for (double deltaY = dy / 2; deltaY < height; deltaY += 2 * dy) {
      // print("$deltaY, ${deltaY + dy}");
      double deltaX = start.dx + dy / 2;
      canvas.drawLine(Offset(deltaX, deltaY), Offset(end.dx + dy / 2, deltaY + dy), paint);
    }
  }
}
