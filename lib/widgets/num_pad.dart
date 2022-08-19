import 'package:flutter/material.dart';

import '../data/data.dart';
import '../script/functions.dart';

class NumberPad extends StatelessWidget {
  double _width;
  final PencilMark _mode;
  NumberPad({Key? key, required double buttonWidth, required PencilMark mode})
      : _width = buttonWidth,
        _mode = mode,
        super(key: key);
  static const List<List<int?>> numberPattern = [
    [7, 8, 9],
    [4, 5, 6],
    [1, 2, 3],
    [0]
  ];
  List colourPattern = [
    Colors.blue.shade800,
    Colors.blue,
    Colors.blue.shade200,
    Colors.cyan.shade300,
    Colors.green.shade700,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.red.shade700,
    Colors.purple.shade700,
    Colors.pink.shade300,
    Colors.grey.shade300,
    Colors.grey,
    Colors.grey.shade700,
    // Colors.grey.shade800,

    // Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    int patternLength = (_mode == PencilMark.Color) ? colourPattern.length : 10;
    int _axisCount = Sqrt(patternLength).round();
    double _gap = _width / 3;
    return SizedBox(
      width: _width * _axisCount + (_axisCount - 1) * _gap + _axisCount,
      child: Wrap(
        textDirection: TextDirection.rtl,
        alignment: WrapAlignment.center,
        runSpacing: _gap,
        spacing: _gap,
        children: List.generate(patternLength, (index) {
          dynamic value = (patternLength - 1) - index;
          return SizedBox(
            height: _width,
            width: _width,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => print(value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.25),
                  backgroundBlendMode: BlendMode.multiply,
                  borderRadius: BorderRadius.circular(4),
                  color: (_mode == PencilMark.Color) ? colourPattern[value] : Colors.transparent,
                ),
                child: getChild(value),
              ),
            ),
          );
        }, growable: false),
      ),
    );
  }

  Widget getChild(value) {
    switch (_mode) {
      case PencilMark.Normal:
        return Center(
          child: Text(
            "$value",
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 18),
          ),
        );

      case PencilMark.Center:
        return Center(
          child: Text(
            "$value",
            style: const TextStyle(fontFamily: 'Consolas', fontSize: 12),
          ),
        );

      case PencilMark.Corner:
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              "$value",
              style: const TextStyle(fontFamily: 'Consolas', fontSize: 12),
            ),
          ),
        );
      default:
        return SizedBox.expand();
      // return Center(
      //   child: Text(
      //     "$value",
      //     style: const TextStyle(fontFamily: 'Consolas', fontSize: 12),
      //   ),
      // );
    }
  }
}
