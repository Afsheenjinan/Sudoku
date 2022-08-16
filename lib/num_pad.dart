import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final double _width;
  const NumberPad({Key? key, required double width})
      : _width = width,
        super(key: key);
  static const List<int?> pattern = [7, 8, 9, 4, 5, 6, 1, 2, 3, null, 0, null];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _width,
      width: _width / 4 * 3,
      child: GridView.count(
        crossAxisCount: 3,
        // crossAxisSpacing: 8,
        // mainAxisSpacing: 8,
        children: List.generate(pattern.length, (index) {
          int? value = pattern[index];
          return (value != null)
              ? InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => print(value),
                  child: Center(
                    child: Text(
                      "$value",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 18),
                    ),
                  ),
                )
              : const SizedBox.expand();
        }),
      ),
    );
  }
}
