import 'package:flutter/material.dart';

import 'data/data.dart';

class NumberPad extends StatelessWidget {
  final double _width;
  final PencilMark _mode;
  NumberPad({Key? key, required double width, required PencilMark mode})
      : _width = width,
        _mode = mode,
        super(key: key);
  static const List<int?> numberPattern = [7, 8, 9, 4, 5, 6, 1, 2, 3, null, 0, null];
  List<MaterialColor> colourPattern = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey,
    Colors.yellow,
    Colors.orange,
    Colors.amber,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    List pattern = (_mode == PencilMark.Color) ? colourPattern : numberPattern;
    return SizedBox(
      height: _width,
      width: _width / 4.2 * 3,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(pattern.length, (index) {
          dynamic value = pattern[index];
          return (value != null)
              ? InkWell(
                  borderRadius: BorderRadius.circular(4),
                  // overlayColor: MaterialStateProperty.all(Colors.blueGrey),
                  onTap: () => print(value),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.25),
                      backgroundBlendMode: BlendMode.multiply,
                      borderRadius: BorderRadius.circular(4),
                      color: (_mode == PencilMark.Color) ? value : Colors.transparent,
                    ),
                    child: getChild(value),
                  ),
                )
              : const SizedBox.expand();
        }),
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
    }
  }
}
