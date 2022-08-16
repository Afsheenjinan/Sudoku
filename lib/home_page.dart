import 'package:flutter/material.dart';
import 'background.dart';
import 'number_grid.dart';
import 'num_pad.dart';
import 'data/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool editMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomPaint(
              painter: BackgroundPainter(9, 9),
              child: Stack(
                children: <Widget>[
                  SudokuGrid(width: 300),
                  NumberGrid(gridPattern: grid, width: 300),
                ],
              ),
            ),
            Switch(
              value: editMode,
              onChanged: (bool state) => setState(() => editMode = !editMode),
            ),
            Container(
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(height: 50, width: 50, child: Text("15")),
                  SizedBox(height: 50, width: 50, child: Text("15")),
                ],
              ),
            ),
            const NumberPad(width: 180),
          ],
        ),
      ),
    );
  }
}

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
