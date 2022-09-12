import 'package:flutter/material.dart';
import 'package:sudoku/include/classes.dart';

import '../data/data.dart';

class NumberPad extends StatelessWidget {
  final double _width;
  final PencilMark _pencilMark;
  final NumberMode _numberMode;

  const NumberPad({Key? key, required double buttonWidth, required PencilMark pencilMark, required NumberMode numberMode})
      : _width = buttonWidth,
        _pencilMark = pencilMark,
        _numberMode = numberMode,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int patternLength = (_numberMode == NumberMode.Colour)
        ? lightThemeColourPalette.length
        : (_numberMode == NumberMode.Letter)
            ? 26 // Letter
            : 10; // Number
    int axisCount = (patternLength / 4).round();
    double gap = _width / 3;
    return SizedBox(
      width: _width * axisCount + (axisCount - 1) * gap + axisCount,
      child: Wrap(
        textDirection: (_numberMode == NumberMode.Letter) ? TextDirection.ltr : TextDirection.rtl,
        alignment: WrapAlignment.center,
        runSpacing: gap,
        spacing: gap,
        children: List.generate(patternLength, (index) {
          dynamic value = (_numberMode == NumberMode.Letter) ? String.fromCharCode(index + 65) : (patternLength - 1) - index;
          return SizedBox(
            height: _width,
            width: _width,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _onButtonTap(value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: getChildWithPencilMarkMode(value),
              ),
            ),
          );
        }, growable: false),
      ),
    );
  }

  void _onButtonTap(value) {
    for (int index in selected) {
      // sudokuPattern[index] = value;
      print("$index = $value");
    }
  }

  Widget getChildWithPencilMarkMode(value) {
    switch (_pencilMark) {
      case PencilMark.Normal:
        return Center(
          child: (_numberMode == NumberMode.Colour)
              ? SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      backgroundBlendMode: BlendMode.multiply,
                      color: lightThemeColourPalette[value],
                    ),
                  ),
                )
              : Text("$value", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 18)),
        );

      case PencilMark.Center:
        return Center(
          child: (_numberMode == NumberMode.Colour)
              ? SizedBox.square(
                  dimension: _width / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: lightThemeColourPalette[value],
                    ),
                  ),
                )
              : Text("$value", style: const TextStyle(fontFamily: 'Consolas', fontSize: 12)),
        );

      case PencilMark.Corner:
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: (_numberMode == NumberMode.Colour)
                ? SizedBox.square(
                    dimension: _width / 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: lightThemeColourPalette[value],
                      ),
                    ),
                  )
                : Text("$value", style: const TextStyle(fontFamily: 'Consolas', fontSize: 12)),
          ),
        );
      default:
        return const SizedBox.expand();
    }
  }
}
