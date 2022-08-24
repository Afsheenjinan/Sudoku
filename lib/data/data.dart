import 'package:flutter/material.dart';

enum PencilMark { Normal, Center, Corner }

enum NumberMode { Number, Letter, Color }

enum GameStatus { Playing, Paused, Completed }

// List<List<int>> grid = List.generate(9, (index) => [1, 2, 9, 7, 5, 6, 3, 8, 4]..shuffle());
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
  Colors.grey.shade800,
  Colors.grey.shade800,
  Colors.black,
];
