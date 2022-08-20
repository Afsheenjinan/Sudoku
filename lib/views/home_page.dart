import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../clock_view.dart';
import '../widgets/background.dart';
import '../widgets/grid_outline.dart';
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
  bool _editMode = false;
  PencilMark _mode = PencilMark.Normal;
  NumberMode _numberMode = NumberMode.Number;

  final List<bool> _pencilMarkSelected = [true, false, false];
  final List<bool> _numberModeSelected = [true, false, false];

  final FocusNode _node = FocusNode();

  Set<LogicalKeyboardKey> ctrlKeys = {LogicalKeyboardKey.control, LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight};
  Set<LogicalKeyboardKey> shiftKeys = {LogicalKeyboardKey.shift, LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight};

  Set<LogicalKeyboardKey> keySet = {};

  @override
  void dispose() {
    _node
      ..removeListener(() {})
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    if (_node.hasFocus == false) _node.requestFocus();
    return KeyboardListener(
      focusNode: _node,
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
                      NumberGrid(gridPattern: grid, width: 300),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DigitalClock(),
                    // SizedBox.square(dimension: 200, child: const AnalogClock()),
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
                    ToggleButtons(
                      fillColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      constraints: const BoxConstraints(minHeight: 24.0, minWidth: 72, maxWidth: 120),
                      onPressed: _changePencilMark,
                      isSelected: _pencilMarkSelected,
                      children: ["Normal", "Center", "Corner"].map((item) => Text(item)).toList(),
                    ),
                    const SizedBox(height: 40),
                    ToggleButtons(
                      fillColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      constraints: const BoxConstraints(minHeight: 24.0, minWidth: 72, maxWidth: 120),
                      onPressed: _changeNumberMode,
                      isSelected: _numberModeSelected,
                      children: ["Number", "Letter", "Color"].map((item) => Text(item)).toList(),
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

  void _changePencilMark(int index) {
    int oldIndex = _pencilMarkSelected.indexOf(true);
    if (oldIndex != index) {
      _pencilMarkSelected[oldIndex] = false;
      _pencilMarkSelected[index] = true;
      _mode = PencilMark.values[index];
      setState(() {});
    }
  }

  void _changeNumberMode(int index) {
    int oldIndex = _numberModeSelected.indexOf(true);
    if (oldIndex != index) {
      _numberModeSelected[oldIndex] = false;
      _numberModeSelected[index] = true;
      _numberMode = NumberMode.values[index];
      setState(() {});
    }
  }

  KeyEventResult _onKeyEvent(KeyEvent event) {
    LogicalKeyboardKey logicalKeyboardKey = event.logicalKey;

    String? _char = event.character;

    if (event is KeyDownEvent) {
      if (_char != null) print(_char);

      if (ctrlKeys.union(shiftKeys).contains(logicalKeyboardKey)) {
        keySet.add(logicalKeyboardKey);
      }

      // print(keySet);
      bool isCtrlPressed = keySet.any(ctrlKeys.contains);
      bool isShiftPressed = keySet.any(shiftKeys.contains);
      if (logicalKeyboardKey == LogicalKeyboardKey.tab) {
        int index = isShiftPressed
            ? (_numberModeSelected.indexOf(true) - 1) % _numberModeSelected.length
            : (_numberModeSelected.indexOf(true) + 1) % _numberModeSelected.length;
        _changeNumberMode(index);
      }

      _mode = getMode(isCtrlPressed, isShiftPressed);
      // if (_regAtoZ.hasMatch(logicalKeyboardKey.keyLabel)) _onAtoZ(logicalKeyboardKey.keyLabel);
    } else {
      keySet.remove(logicalKeyboardKey);
      bool isCtrlPressed = keySet.any(ctrlKeys.contains);
      bool isShiftPressed = keySet.any(shiftKeys.contains);

      _mode = getMode(isCtrlPressed, isShiftPressed);
    }

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
}
