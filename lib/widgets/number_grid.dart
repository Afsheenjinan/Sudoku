import 'package:flutter/material.dart';

class NumberGrid extends StatefulWidget {
  List<List<int>> gridPattern;

  double width;

  NumberGrid({Key? key, required this.gridPattern, required this.width}) : super(key: key);

  @override
  State<NumberGrid> createState() => _NumberGridState();
}

class _NumberGridState extends State<NumberGrid> {
  Set selected = {};

  int currentCell = 81;

  @override
  Widget build(BuildContext context) {
    final List<int> _flatten_grid = widget.gridPattern.expand((element) => element).toList();
    return SizedBox(
      height: widget.width,
      width: widget.width,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: 81,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) => setState(() => selected.clear()),
            onPanUpdate: (details) => onDrag(details, index),
            onTap: () => selectContainer(index),
            child: Container(
              decoration: BoxDecoration(border: selected.contains(index) ? setBorder(index, Colors.green, 4) : null),
              child: Center(
                child: Text(
                  _flatten_grid[index].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void selectContainer(int index) {
    print("Container was tapped $index");
    // print(index ~/ 9);
    // print(index % 9);
    selected.clear();
    setState(() {
      selected.add(index);
    });
  }

  void onDrag(DragUpdateDetails details, int index) {
    Offset offset = details.localPosition / (widget.width / 9);

    int x = ((index % 9) + offset.dx.floor());
    int y = ((index ~/ 9) + offset.dy.floor());

    if (x > 8 || x < 0 || y > 8 || y < 0) return;
    // print("$x, $y");
    // print("${x + y * 9}");

    int value = x + y * 9;
    // print(value);
    if (currentCell == value) return;

    if (selected.contains(value)) {
      selected.remove(value);
    } else {
      selected.add(value);
    }
    currentCell = value;

    setState(() {});

    // selected
  }

  Border? setBorder(int index, Color color, double width) {
    int x = (index % 9);
    int y = (index ~/ 9);
    print(index);
    print("x: $x, y: $y");

    int up = x + (y - 1) * 9;
    int down = x + (y + 1) * 9;
    int left = (x > 0) ? (x - 1) + y * 9 : -1;
    int right = (x < 8) ? (x + 1) + y * 9 : -1;
    print("x : $x");
    print("up : $up, down : $down");
    print("left : $left, right : $right");

    BorderSide borderSide = BorderSide(color: color, width: width);
    // BorderSide noBorder = BorderSide(color: Colors.transparent, width: 3);
    BorderSide noBorder = BorderSide(color: Colors.transparent, width: width);
    // BorderSide noBorder = BorderSide.none;

    return Border(
      top: selected.contains(up) ? noBorder : borderSide,
      left: selected.contains(left) ? noBorder : borderSide,
      right: selected.contains(right) ? noBorder : borderSide,
      bottom: selected.contains(down) ? noBorder : borderSide,
    );

    // return Border.lerp(
    //     Border(
    //       top: selected.contains(up) ? noBorder : borderSide,
    //       left: selected.contains(left) ? noBorder : borderSide,
    //       right: selected.contains(right) ? noBorder : borderSide,
    //       bottom: selected.contains(down) ? noBorder : borderSide,
    //     ),
    //     Border.all(color: Colors.transparent, width: width, style: BorderStyle.solid),
    //     1 / 2);
  }
}
