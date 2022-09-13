import 'package:flutter/material.dart';
import '../include/classes.dart';

class NumberGrid extends StatelessWidget {
  final List<List<GridItems>> gridPattern;

  final double cellWidth;
  final bool isCtrl, isShift;
  final Coord size;

  /// Takes the values [index] and [isCtrl] and returns their sum. Optionally a
  /// third parameter [c] can be provided and it will be added to the
  /// sum as well.
  /// @funParameter func(asd)
  final void Function(int index, bool isCtrl, bool isShift) onPressed;
  final void Function(DragUpdateDetails, int, double, bool) onDrag;
  final void Function(DragStartDetails, bool, bool) onDragStart;

  NumberGrid({
    Key? key,
    required this.gridPattern,
    required this.cellWidth,
    required this.isCtrl,
    required this.isShift,
    required this.onPressed,
    required this.size,
    required this.onDrag,
    required this.onDragStart,
  }) : super(key: key);

  final List<Alignment> cornerAlignmentList = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topCenter,
    Alignment.bottomCenter,
  ];

  @override
  Widget build(BuildContext context) {
    final List<GridItems> flattenGrid = gridPattern.expand((element) => element).toList();
    return SizedBox(
      height: cellWidth * size.y,
      width: cellWidth * size.x,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.x,
        ),
        itemCount: size.product,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onPressed(index, isCtrl, isShift),
            onPanStart: (details) => onDragStart(details, isCtrl, isShift),
            onPanUpdate: (details) => onDrag(details, index, cellWidth, isCtrl),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: selectedCoordinates.contains(Coord.fromIndex(index))
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
                          CornerPencilMarksWidget(alignment: cornerAlignmentList[flattenGrid[index].cornerPencilMarks.indexOf(item)], character: item)
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

//   Border? setBorder(int index, Color color, double width) {
//     int x = (index % 9);
//     int y = (index ~/ 9);

// TODO:
//Coord - Coord
//Coord - int

//     Coord.fromIndex(index - size);

//     Coord up = Coord(x, (y - 1));
//     Coord down = Coord(x, (y + 1));
//     Coord left = Coord((x - 1), y);
//     Coord right = Coord((x + 1), y);

//     // int up = x + (y - 1) * 9;
//     // int down = x + (y + 1) * 9;
//     // int left = (x > 0) ? (x - 1) + y * 9 : -1;
//     // int right = (x < 8) ? (x + 1) + y * 9 : -1;
//     if (kDebugMode) {
//       print("--------------------($x,$y)-----------------");
//       print("     $up");
//       print("$left | $index | $right");
//       print("     $down");
//     }

//     BorderSide borderSide = BorderSide(color: color, width: width);
//     BorderSide noBorder = BorderSide(color: Colors.transparent, width: width);
//     // BorderSide noBorder = BorderSide.none;

//     return Border(
//       top: selectedCoordinates.contains(up) ? noBorder : borderSide,
//       left: selectedCoordinates.contains(left) ? noBorder : borderSide,
//       right: selectedCoordinates.contains(right) ? noBorder : borderSide,
//       bottom: selectedCoordinates.contains(down) ? noBorder : borderSide,
//     );

//     // return Border.lerp(
//     //     Border(
//     //       top: selected.contains(up) ? noBorder : borderSide,
//     //       left: selected.contains(left) ? noBorder : borderSide,
//     //       right: selected.contains(right) ? noBorder : borderSide,
//     //       bottom: selected.contains(down) ? noBorder : borderSide,
//     //     ),
//     //     Border.all(color: Colors.transparent, width: width, style: BorderStyle.solid),
//     //     1 / 2);
//   }
}

class CornerPencilMarksWidget extends StatelessWidget {
  const CornerPencilMarksWidget({Key? key, required this.alignment, required this.character}) : super(key: key);

  final Alignment alignment;
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ColoredBox(
        color: character.color ?? Colors.transparent,
        child: (character.number != null)
            ? Text(
                "${character.number}",
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
