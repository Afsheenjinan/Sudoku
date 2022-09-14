import 'package:flutter/material.dart';
import 'package:sudoku/include/classes.dart';

import '../data/data.dart';

class NumberPad extends StatelessWidget {
  final double buttonWidth;
  final PencilMark pencilMark;
  final NumberMode numberMode;
  final void Function(Character) onButtonTap;

  const NumberPad({Key? key, required this.buttonWidth, required this.pencilMark, required this.numberMode, required this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int patternLength = (numberMode == NumberMode.Colour)
        ? lightThemeColourPalette.length
        : (numberMode == NumberMode.Letter)
            ? 26 // Letter
            : 10; // Number
    int axisCount = (patternLength / 4).round();
    double gap = buttonWidth / 3;
    return SizedBox(
      width: buttonWidth * axisCount + (axisCount - 1) * gap + axisCount,
      child: Wrap(
        textDirection: (numberMode == NumberMode.Letter) ? TextDirection.ltr : TextDirection.rtl,
        alignment: WrapAlignment.center,
        runSpacing: gap,
        spacing: gap,
        children: List.generate(patternLength, (index) {
          // dynamic value = (_numberMode == NumberMode.Letter) ? String.fromCharCode(index + 65) : (patternLength - 1) - index;
          Character character;

          int val = patternLength - 1 - index;

          if (numberMode == NumberMode.Letter) {
            character = Character.fromLetter(String.fromCharCode(index + 65));
          } else if (numberMode == NumberMode.Number) {
            character = Character(number: val);
          } else {
            character = Character(color: lightThemeColourPalette[val]);
          }
          return SizedBox(
            height: buttonWidth,
            width: buttonWidth,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => onButtonTap(character),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: getChildWithPencilMarkMode(character),
              ),
            ),
          );
        }, growable: false),
      ),
    );
  }

  Widget getChildWithPencilMarkMode(Character char) {
    switch (pencilMark) {
      case PencilMark.Normal:
        return Center(
          child: (numberMode == NumberMode.Colour)
              ? SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      backgroundBlendMode: BlendMode.multiply,
                      color: char.color,
                    ),
                  ),
                )
              : Text("${char.number ?? char.letter ?? ''}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 18)),
        );

      case PencilMark.Center:
        return Center(
          child: (numberMode == NumberMode.Colour)
              ? SizedBox.square(
                  dimension: buttonWidth / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: char.color,
                    ),
                  ),
                )
              : Text("${char.number ?? char.letter ?? ''}", style: const TextStyle(fontFamily: 'Consolas', fontSize: 12)),
        );

      case PencilMark.Corner:
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: (numberMode == NumberMode.Colour)
                ? SizedBox.square(
                    dimension: buttonWidth / 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: char.color,
                      ),
                    ),
                  )
                : Text("${char.number ?? char.letter ?? ''}", style: const TextStyle(fontFamily: 'Consolas', fontSize: 12)),
          ),
        );
      default:
        return const SizedBox.expand();
    }
  }
}
