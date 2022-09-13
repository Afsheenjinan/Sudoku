import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../include/classes.dart';

class NumberGrid extends StatefulWidget {
  final List<List<GridItems>> gridPattern;

  final double cellWidth;
  final bool isCtrl,isShift;
  final int xCount, yCount;

  const NumberGrid(
      {Key? key,
      required this.gridPattern,
      required this.cellWidth,
      required this.isCtrl,
      required this.isShift,
      required this.xCount,
      required this.yCount})
      : super(key: key);

  @override
  State<NumberGrid> createState() => _NumberGridState();
}

class _NumberGridState extends State<NumberGrid> {
  List<Alignment> cornerAlignmentList = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topCenter,
    Alignment.bottomCenter,
  ];

  @override
  Widget build(BuildContext context) {
    final List<GridItems> flattenGrid = widget.gridPattern.expand((element) => element).toList();
    return SizedBox(
      height: widget.cellWidth* widget.yCount,
      width: widget.cellWidth* widget.xCount,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.xCount,
        ),
        itemCount: widget.xCount * widget.yCount,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) => setState(() {
              if (!(widget.isCtrl || widget.isShift)) selectedCoordinates.clear();
            }),
            onPanUpdate: (details) => onDrag(details, index),
            onTap: () => selectContainer(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: indexInSelected(index)
                      ? Colors.green.withOpacity(0.25)
                      : (flattenGrid[index].character?.color != null)
                          ? flattenGrid[index].character?.color
                          : Colors.transparent),
              // decoration: BoxDecoration(border: selected.contains(index) ? setBorder(index, Colors.green, 4) : null),
              child: (flattenGrid[index].character?.number != null)
                  ? Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        // fit: BoxFit.scaleDown,
                        child: Text(
                          flattenGrid[index].character!.number.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Consolas', fontSize: 24),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                flattenGrid[index].cornerPencilMarks.map((e) => e.number).where((element) => element != null).join().isEmpty
                                    ? Text(" ")
                                    : Text(
                                        flattenGrid[index].centerPencilMarks.map((e) => e.number).where((element) => element != null).join(),
                                        style: const TextStyle(fontFamily: 'Consolas', fontSize: 10),
                                      ),
                                for (var i in flattenGrid[index].centerPencilMarks.map((e) => e.color).where((element) => element != null))
                                  Container(color: i, height: 6, width: 6)
                              ],
                            ),
                          ),
                        ),
                        for (Character item in flattenGrid[index].cornerPencilMarks)
                          CornerPencilMarksWidget(alignment: cornerAlignmentList[flattenGrid[index].cornerPencilMarks.indexOf(item)], number: item)
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  bool indexInSelected(int index) {
    Coord xy = Coord.fromIndex(index);
    return selectedCoordinates.contains(xy);
  }

  void selectContainer(int index) {
    print("Container was tapped $index");

    Coord xy = Coord.fromIndex(index);

    if (!(widget.isCtrl || widget.isShift)) selectedCoordinates.clear();

    if (selectedCoordinates.contains(xy)) {
      selectedCoordinates.remove(xy);
    } else {
      selectedCoordinates.add(xy);
    }

    setState(() {});
  }

  void onDrag(DragUpdateDetails details, int index) {
    Offset offset = details.localPosition / widget.cellWidth;
    Coord xy = Coord.fromOffset(index, offset);
    print("Container was draged $xy");


    if (xy.x > 8 || xy.x < 0 || xy.y > 8 || xy.y < 0) return;
    // print("$x, $y");
    // print("${x + y * 9}");

    // int value = x + y * 9;
    // print(value);

    if (widget.isCtrl) {
      if (selectedCoordinates.contains(xy)) selectedCoordinates.remove(xy);
    } else {
      if (!selectedCoordinates.contains(xy)) selectedCoordinates.add(xy);
    }

    setState(() {});
  }

  Border? setBorder(int index, Color color, double width) {
    int x = (index % 9);
    int y = (index ~/ 9);

    Coord up = Coord(x, (y - 1));
    Coord down = Coord(x, (y + 1));
    Coord left = Coord((x - 1), y);
    Coord right = Coord((x + 1), y);

    // int up = x + (y - 1) * 9;
    // int down = x + (y + 1) * 9;
    // int left = (x > 0) ? (x - 1) + y * 9 : -1;
    // int right = (x < 8) ? (x + 1) + y * 9 : -1;
    if (kDebugMode) {
      print("--------------------($x,$y)-----------------");
      print("     $up");
      print("$left | $index | $right");
      print("     $down");
    }

    BorderSide borderSide = BorderSide(color: color, width: width);
    BorderSide noBorder = BorderSide(color: Colors.transparent, width: width);
    // BorderSide noBorder = BorderSide.none;

    return Border(
      top: selectedCoordinates.contains(up) ? noBorder : borderSide,
      left: selectedCoordinates.contains(left) ? noBorder : borderSide,
      right: selectedCoordinates.contains(right) ? noBorder : borderSide,
      bottom: selectedCoordinates.contains(down) ? noBorder : borderSide,
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

class CornerPencilMarksWidget extends StatelessWidget {
  const CornerPencilMarksWidget({Key? key, required this.alignment, required this.number}) : super(key: key);

  final Alignment alignment;
  final Character number;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ColoredBox(
        color: number.color ?? Colors.transparent,
        child: (number.number != null)
            ? Text(
                "${number.number}",
                style: const TextStyle(fontFamily: 'Consolas', fontSize: 10),
              )
            : const SizedBox(
                height: 6,
                width: 6,
              ),
      ),
    );
  }
}
