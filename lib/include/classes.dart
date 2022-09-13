import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GridItems {
  Character? character;
  final List<Character> centerPencilMarks = [];
  final List<Character> cornerPencilMarks = [];

  void addCharacter(Character other) {
    character = (character == other) ? null : other;
  }

  void addCenterPencilMark(Character other) {
    centerPencilMarks.contains(other) ? centerPencilMarks.remove(other) : centerPencilMarks.add(other);
  }

  void addCornerPencilMark(Character other) {
    cornerPencilMarks.contains(other) ? cornerPencilMarks.remove(other) : cornerPencilMarks.add(other);
  }

  @override
  String toString() => 'GridItem \n\tcharacter: $character\n\tcenterPencilMarks: $cornerPencilMarks\n\tcenterPencilMarks: $cornerPencilMarks';
}

class Character extends Equatable {
  final int? number;
  final String? letter;
  final Color? color;

  const Character({this.letter, this.number, this.color});

  factory Character.fromNumber(int n) => Character(number: n);
  factory Character.fromLetter(String l) => Character(letter: l);
  factory Character.fromColor(Color c) => Character(color: c);

  @override
  List get props => [number, letter, color];

  @override
  String toString() => "${number ?? letter ?? 'RGB(${color?.red},${color?.green},${color?.blue})'}";
}

class Coord extends Equatable {
  final int x;
  final int y;

  const Coord(this.x, this.y);

  get product => x * y;

  factory Coord.fromIndex(int index) {
    int x = index % 9;
    int y = index ~/ 9;
    return Coord(x, y);
  }

  factory Coord.fromOffset(int index, Offset offset) {
    int x = (index % 9) + offset.dx.floor();
    int y = (index ~/ 9) + offset.dy.floor();
    return Coord(x, y);
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '($x,$y)';

}

class SudokuPattern {
  List<List<GridItems>> grid = [];
  List<List<Coord>> regions = [];
}
Set<Coord> selectedCoordinates = {};

