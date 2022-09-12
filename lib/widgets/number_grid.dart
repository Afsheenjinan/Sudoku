import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import '../include/classes.dart';

class NumberGrid extends StatefulWidget {
  final List<List<GridItems>> gridPattern;

  final double width;

  final bool isCtrl;
  final bool isShift;

  const NumberGrid({Key? key, required this.gridPattern, required this.width, required this.isCtrl, required this.isShift}) : super(key: key);

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
            onPanStart: (details) => setState(() {
              if (!(widget.isCtrl || widget.isShift)) selected.clear();
            }),
            onPanUpdate: (details) => onDrag(details, index),
            onTap: () => selectContainer(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: selected.contains(index)
                      ? Colors.green.withOpacity(0.25)
                      : (flattenGrid[index].character?.color != null)
                          ? flattenGrid[index].character?.color
                          : Colors.transparent),
              // decoration: BoxDecoration(border: selected.contains(index) ? setBorder(index, Colors.green, 4) : null),
              child: (flattenGrid[index].character?.value != null)
                  ? Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        // fit: BoxFit.scaleDown,
                        child: Text(
                          flattenGrid[index].character!.value.toString(),
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
                                flattenGrid[index].cornerPencilMarks.map((e) => e.value).where((element) => element != null).join().isEmpty
                                    ? Text(" ")
                                    : Text(
                                        flattenGrid[index].centerPencilMarks.map((e) => e.value).where((element) => element != null).join(),
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

  void selectContainer(int index) {
    print("Container was tapped $index");

    if (!(widget.isCtrl || widget.isShift)) selected.clear();

    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }

    setState(() {});
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

    if (widget.isCtrl) {
      if (selected.contains(value)) selected.remove(value);
    } else {
      if (!selected.contains(value)) selected.add(value);
    }

    setState(() {});
  }

  Border? setBorder(int index, Color color, double width) {
    int x = (index % 9);
    int y = (index ~/ 9);

    int up = x + (y - 1) * 9;
    int down = x + (y + 1) * 9;
    int left = (x > 0) ? (x - 1) + y * 9 : -1;
    int right = (x < 8) ? (x + 1) + y * 9 : -1;
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
        child: (number.value != null)
            ? Text(
                "${number.value}",
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
