import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GridItems {
  Number? number;
  final List<Number> centerPencilMarks = [];
  final List<Number> cornerPencilMarks = [];

  void addNumber(Number other) {
    number = (number == other) ? null : other;
  }

  void addCenterPencilMark(Number other) {
    centerPencilMarks.contains(other) ? centerPencilMarks.remove(other) : centerPencilMarks.add(other);
  }

  void addCornerPencilMark(Number other) {
    cornerPencilMarks.contains(other) ? cornerPencilMarks.remove(other) : cornerPencilMarks.add(other);
  }
}

class Number extends Equatable {
  final dynamic value;
  final Color? color;

  const Number({this.value, this.color});

  factory Number.fromValue(int val) => Number(value: val);
  factory Number.fromColor(Color col) => Number(color: col);

  @override
  List get props => [value, color];
}

class SudokuPattern {
  List<List<GridItems>> grid = [];
}
