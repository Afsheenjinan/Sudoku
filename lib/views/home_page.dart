import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool editMode = false;
  PencilMark _mode = PencilMark.Normal;

  List<bool> _isButtonSelected = [true, false, false, false];

  final FocusNode _node = FocusNode();

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Edit Mode"),
                        Switch(value: editMode, onChanged: (bool state) => setState(() => editMode = !editMode)),
                      ],
                    ),
                    SizedBox(height: 40),
                    NumberPad(buttonWidth: 36, mode: _mode),
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

  KeyEventResult _onKeyEvent(KeyEvent event) {
    LogicalKeyboardKey logicalKeyboardKey = event.logicalKey;
    if (event is KeyDownEvent) {
      print(event.character);
      keySet.add(logicalKeyboardKey);
      print(keySet);
      _mode = getMode(keySet);
      // if (_regAtoZ.hasMatch(logicalKeyboardKey.keyLabel)) _onAtoZ(logicalKeyboardKey.keyLabel);
    } else {
      keySet.remove(logicalKeyboardKey);
      _mode = getMode(keySet);
    }
    _changeMode(PencilMark.values.indexOf(_mode));

    return KeyEventResult.handled;
  }

  PencilMark getMode(Set<LogicalKeyboardKey> keyset) {
    bool isCtrlPressed = keyset.any({LogicalKeyboardKey.control, LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight}.contains);
    bool isShiftPressed = keyset.any({LogicalKeyboardKey.shift, LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight}.contains);

    // print(keyset.map((e) => e.keyLabel));

    return isCtrlPressed && isShiftPressed
        ? PencilMark.Color
        : isCtrlPressed
            ? PencilMark.Center
            : isShiftPressed
                ? PencilMark.Corner
                : PencilMark.Normal;
  }
}
