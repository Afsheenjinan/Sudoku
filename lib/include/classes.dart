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
}

class Character extends Equatable {
  final dynamic value;
  final Color? color;

  const Character({this.value, this.color});

  factory Character.fromValue(int val) => Character(value: val);
  factory Character.fromColor(Color col) => Character(color: col);

  @override
  List get props => [value, color];
}

class Coord {
  int x;
  int y;

  Coord(this.x, this.y);
}

class SudokuPattern {
  List<List<GridItems>> grid = [];
  List<List<Coord>> regions = [];
}

SudokuPattern sudokuPattern = SudokuPattern()
  ..grid = List.generate(9, (index) => List.generate(9, (index) => GridItems()..character = Character(value: index + 1))..shuffle());
