import 'package:flutter/material.dart';
import 'dart:async';

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
          _pausedDuration += const Duration(seconds: 1);
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
        const SizedBox(width: 32),
        IconButton(
          iconSize: 32,
          icon: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause),
          onPressed: () => setState(() => _isPaused = !_isPaused),
          splashRadius: 16,
          tooltip: _isPaused ? "Resume" : "Pause",
        )
      ],
    );
  }

  String pad(int n) => n.toString().padLeft(2, "0");
}
