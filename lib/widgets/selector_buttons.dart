import 'package:flutter/material.dart';

class ModeSelectorButtons extends StatelessWidget {
  final List<bool> _selectedItems;
  final List<String> _items;

  final void Function(int) _onPressed;

  const ModeSelectorButtons({
    required List<String> items,
    required List<bool> selectedItems,
    required void Function(int) onPressed,
    Key? key,
  })  : _items = items,
        _selectedItems = selectedItems,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      fillColor: Colors.transparent,
      borderRadius: BorderRadius.circular(5.0),
      constraints: const BoxConstraints(minHeight: 24.0, minWidth: 72, maxWidth: 120),
      onPressed: _onPressed,
      isSelected: _selectedItems,
      children: _items.map((item) => Text(item)).toList(),
    );
  }
}
