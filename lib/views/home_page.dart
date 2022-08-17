import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/number_grid.dart';
import '../widgets/num_pad.dart';
import '../data/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool editMode = false;
  PencilMark _mode = PencilMark.Normal;

  List<bool> _isButtonSelected = [true, false, false, false];
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit Mode"),
                    Switch(value: editMode, onChanged: (bool state) => setState(() => editMode = !editMode)),
                  ],
                ),
                SizedBox(height: 40),
                NumberPad(width: 180, mode: _mode),
                SizedBox(height: 40),
                ToggleButtons(
                  fillColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(5.0),
                  constraints: const BoxConstraints(minHeight: 24.0, minWidth: 72, maxWidth: 120),
                  onPressed: _changeMode,
                  isSelected: _isButtonSelected,
                  children: ["Number", "Center", "Corner", "Color"].map((item) => Text(item)).toList(),
                ),
              ],
            ),
            editMode
                ? ColoredBox(
                    color: Colors.blue.shade100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: "Bell Button",
                          splashRadius: 18,
                          color: Colors.green,
                          icon: Icon(Icons.add_alert),
                          onPressed: () {},
                        ),
                        IconButton(
                          tooltip: "Left",
                          splashRadius: 18,
                          color: Colors.green,
                          icon: Icon(Icons.west_sharp),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                : SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  void _changeMode(int index) {
    int oldIndex = _isButtonSelected.indexOf(true);
    if (oldIndex != index) {
      _isButtonSelected[oldIndex] = false;
      _isButtonSelected[index] = true;
      _mode = PencilMark.values[index];

      setState(() {});
    }
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
