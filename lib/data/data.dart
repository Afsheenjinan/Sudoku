import 'package:flutter/material.dart';

enum PencilMark { Normal, Center, Corner }

enum NumberMode { Number, Letter, Color }

List<List<int>> grid = List.generate(9, (index) => [1, 2, 9, 7, 5, 6, 3, 8, 4]..shuffle());
List colourPalette = [
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
  Colors.grey.shade400,
  Colors.grey.shade600,
  Colors.grey.shade700,
  // Colors.grey.shade800,
  // Colors.black,
];

class GridItems {
  int? _number;
  final Set<int> _centerPencilMarks = {};
  final Set<int> _cornerPencilMarks = {};

  set number(int num) => _number;
  set addCenterPencilMark(int num) => _centerPencilMarks.add(num);
  set addCornerPencilMark(int num) => _cornerPencilMarks.add(num);
}
