import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../include/classes.dart';
import '../widgets/clock_widget.dart';
import '../widgets/background.dart';
import '../widgets/grid_outline.dart';
import '../widgets/number_grid.dart';
import '../widgets/num_pad.dart';
import '../data/data.dart';
import '../widgets/selector_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _editMode = false;
  PencilMark _mode = PencilMark.Normal;
  NumberMode _numberMode = NumberMode.Number;

  final List<bool> _pencilMarkButtonsSelected = [true, false, false];
  final List<bool> _numberModeButtonsSelected = [true, false, false];

  final FocusNode _focusNode = FocusNode(skipTraversal: true);

  final Set<LogicalKeyboardKey> ctrlKeys = {LogicalKeyboardKey.control, LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight};
  final Set<LogicalKeyboardKey> shiftKeys = {LogicalKeyboardKey.shift, LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight};

  Set<LogicalKeyboardKey> keySet = {};

  bool isCtrlPressed = false;
  bool isShiftPressed = false;

  SudokuPattern sudokuPattern = SudokuPattern()
    ..grid = List.generate(9, (index) => List.generate(9, (index) => GridItems()..number = Number(value: index + 1))..shuffle());

  @override
  void initState() {
    sudokuPattern.grid[0][6].number = null;
    sudokuPattern.grid[0][8].number = null;
    sudokuPattern.grid[0][8].number = Number(color: Colors.amberAccent);
    // sudokuPattern.grid[0][8].backgroundColors.add(Colors.amber);
    sudokuPattern.grid[0][6].centerPencilMarks.add(const Number(value: 5));
    sudokuPattern.grid[0][6].centerPencilMarks.add(const Number(value: 6));
    sudokuPattern.grid[0][6].centerPencilMarks.addAll({const Number(color: Colors.brown)});

    sudokuPattern.grid[5][3].number = Number(value: "D", color: Colors.yellow.shade300);

    sudokuPattern.grid[0][6].cornerPencilMarks.addAll({const Number(value: 7), const Number(value: 4), const Number(value: 3)});
    sudokuPattern.grid[6][5].number = null;
    sudokuPattern.grid[6][5].centerPencilMarks.add(const Number(value: 7));
    sudokuPattern.grid[6][5].centerPencilMarks.add(const Number(value: 5));
    sudokuPattern.grid[6][5].cornerPencilMarks.addAll({const Number(value: 8), const Number(value: 5)});
    sudokuPattern.grid[3][1].number = null;
    sudokuPattern.grid[3][1].centerPencilMarks.addAll({
      const Number(value: 9),
      const Number(value: 7),
      const Number(value: 8),
      const Number(value: 1),
      const Number(value: 2),
      const Number(value: 3)
    });
    sudokuPattern.grid[3][1].cornerPencilMarks.add(const Number(value: 0));
    sudokuPattern.grid[7][2].number = null;
    sudokuPattern.grid[7][2].centerPencilMarks.addAll({
      const Number(value: 9),
      const Number(value: 7),
      const Number(value: 8),
      const Number(value: 1),
      const Number(value: 2),
    });
    sudokuPattern.grid[7][2].centerPencilMarks.addAll({const Number(color: Colors.brown), const Number(color: Colors.green)});
    sudokuPattern.grid[7][2].cornerPencilMarks.addAll({const Number(color: Colors.blue), const Number(color: Colors.orange)});
    sudokuPattern.grid[7][2].cornerPencilMarks.add(const Number(value: 0));

    super.initState();
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(() {})
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(sudokuPattern.grid.);
    print("build");
    print(isCtrlPressed || isShiftPressed);
    if (_focusNode.hasFocus == false) _focusNode.requestFocus();
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: SafeArea(
        child: Scaffold(
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
                      NumberGrid(gridPattern: sudokuPattern.grid, width: 300, isCtrl: isCtrlPressed, isShift: isShiftPressed),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DigitalClock(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Edit Mode"),
                        Switch(value: _editMode, onChanged: (bool state) => setState(() => _editMode = !_editMode)),
                      ],
                    ),
                    const SizedBox(height: 40),
                    NumberPad(buttonWidth: 36, pencilMark: _mode, numberMode: _numberMode),
                    const SizedBox(height: 40),
                    ModeSelectorButtons(
                      items: ["Normal", "Center", "Corner"],
                      selectedItems: _pencilMarkButtonsSelected,
                      onPressed: _changePencilMark,
                    ),
                    const SizedBox(height: 40),
                    ModeSelectorButtons(
                      items: ["Number", "Letter", "Color"],
                      selectedItems: _numberModeButtonsSelected,
                      onPressed: _changeNumberMode,
                    ),
                  ],
                ),

                // TODO :add lines and other drawings
                _editMode
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
                              icon: const Icon(Icons.add_alert),
                              onPressed: () {},
                            ),
                            IconButton(
                              tooltip: "Left",
                              splashRadius: 18,
                              color: Colors.green,
                              icon: const Icon(Icons.west_sharp),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _onKeyEvent(KeyEvent event) {
    LogicalKeyboardKey logicalKeyboardKey = event.logicalKey;

    String? char = event.character;

    if (event is KeyDownEvent) {
      if (char != null) print(char);
      if (ctrlKeys.union(shiftKeys).contains(logicalKeyboardKey)) keySet.add(logicalKeyboardKey);

      isCtrlPressed = keySet.any(ctrlKeys.contains);
      isShiftPressed = keySet.any(shiftKeys.contains);

      // if TAB pressed shift along
      if (logicalKeyboardKey == LogicalKeyboardKey.tab || logicalKeyboardKey == LogicalKeyboardKey.space) {
        int index = isShiftPressed
            ? (_numberModeButtonsSelected.indexOf(true) - 1) % _numberModeButtonsSelected.length
            : (_numberModeButtonsSelected.indexOf(true) + 1) % _numberModeButtonsSelected.length;
        _changeNumberMode(index);
      }

      // if (_regAtoZ.hasMatch(logicalKeyboardKey.keyLabel)) _onAtoZ(logicalKeyboardKey.keyLabel);
    } else {
      keySet.remove(logicalKeyboardKey);
      isCtrlPressed = keySet.any(ctrlKeys.contains);
      isShiftPressed = keySet.any(shiftKeys.contains);
    }
    _mode = getMode(isCtrlPressed, isShiftPressed);

    _changePencilMark(PencilMark.values.indexOf(_mode));

    return KeyEventResult.handled;
  }

  PencilMark getMode(bool ctrl, bool shift) {
    return ctrl && shift
        ? PencilMark.Corner
        : shift
            ? PencilMark.Corner
            : ctrl
                ? PencilMark.Center
                : PencilMark.Normal;
  }

  void _changePencilMark(int index) {
    int oldIndex = _pencilMarkButtonsSelected.indexOf(true);
    if (oldIndex != index) {
      _pencilMarkButtonsSelected[oldIndex] = false;
      _pencilMarkButtonsSelected[index] = true;
      _mode = PencilMark.values[index];
      setState(() {});
    }
  }

  void _changeNumberMode(int index) {
    int oldIndex = _numberModeButtonsSelected.indexOf(true);
    if (oldIndex != index) {
      _numberModeButtonsSelected[oldIndex] = false;
      _numberModeButtonsSelected[index] = true;
      _numberMode = NumberMode.values[index];
      setState(() {});
    }
  }
}
