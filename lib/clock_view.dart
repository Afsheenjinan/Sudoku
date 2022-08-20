import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'script/functions.dart';

class AnalogClock extends StatefulWidget {
  const AnalogClock({Key? key}) : super(key: key);

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    timer.tick;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(-PI / 2),
      child: CustomPaint(
        painter: ClockPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  DateTime dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    Color color = Colors.black;
    Offset centerPoint = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 4, size.height / 4);

    double secAngle = dateTime.second * 6; // 360/60
    double minAngle = dateTime.minute * 6; // 360/60
    double hrsAngle = dateTime.hour * 30; // 360/12

    Paint fillBrush = Paint()..color = color;
    Paint strokeBrush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    // Paint minHandBrush = Paint()
    //   ..strokeWidth = 8
    //   ..strokeCap = StrokeCap.round
    //   ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.purple]).createShader(Rect.fromCircle(center: centerPoint, radius: radius));
    Paint secHandBrush = Paint()
      ..strokeWidth = radius * 0.04
      ..strokeCap = StrokeCap.round
      ..color = color;
    Paint minHandBrush = Paint()
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round
      ..color = color;
    Paint hrsHandBrush = Paint()
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round
      ..color = color;
    Paint markerHandBrush = Paint()
      ..strokeWidth = radius * 0.01
      ..strokeCap = StrokeCap.round
      ..color = color;

    Offset secXY = getLineParams(centerPoint, radius * 0.7, secAngle);
    Offset minXY = getLineParams(centerPoint, radius * 0.6, minAngle);
    Offset hrsXY = getLineParams(centerPoint, radius * 0.4, hrsAngle);

    canvas.drawCircle(centerPoint, radius, strokeBrush);
    canvas.drawLine(centerPoint, secXY, secHandBrush);
    canvas.drawLine(centerPoint, minXY, minHandBrush);
    canvas.drawLine(centerPoint, hrsXY, hrsHandBrush);
    canvas.drawCircle(centerPoint, 8, fillBrush);

    for (int i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        canvas.drawLine(
            getLineParams(centerPoint, radius * 0.7, i.toDouble()), getLineParams(centerPoint, radius * 0.9, i.toDouble()), markerHandBrush);
      } else {
        canvas.drawLine(
            getLineParams(centerPoint, radius * 0.8, i.toDouble()), getLineParams(centerPoint, radius * 0.9, i.toDouble()), markerHandBrush);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset getLineParams(Offset start, double length, double angle) => Offset(start.dx + length * Cos(angle), start.dy + length * Sin(angle));

class DigitalClock extends StatefulWidget {
  const DigitalClock({Key? key}) : super(key: key);
  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _clockTimer;

  bool _isPaused = false;
  Duration _pausedDuration = const Duration(seconds: 0);
  Duration _elapsedDuration = const Duration(seconds: 0);
  final DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _clockTimer = createTimer();
    super.initState();
  }

  Timer createTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(() {
        if (_isPaused) {
          _pausedDuration += Duration(seconds: 1);
        } else {
          _elapsedDuration = DateTime.now().difference(_dateTime) - _pausedDuration;
        }
      }),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${_elapsedDuration.inHours}:${pad(_elapsedDuration.inMinutes.remainder(60))}:${pad(_elapsedDuration.inSeconds.remainder(60))}"),
        IconButton(
          iconSize: 32,
          icon: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause),
          onPressed: () => _isPaused = !_isPaused,
          splashRadius: 16,
          tooltip: _isPaused ? "Resume" : "Pause",
        )
      ],
    );
  }

  String pad(int n) => n.toString().padLeft(2, "0");
}
