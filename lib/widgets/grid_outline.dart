import 'package:flutter/material.dart';

class SudokuGrid extends StatelessWidget {
  double width;

  SudokuGrid({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: width,
      child: GridPaper(
        divisions: 3,
        interval: width / 3,
        subdivisions: 1,
        color: Colors.black,
      ),
    );
  }
}
