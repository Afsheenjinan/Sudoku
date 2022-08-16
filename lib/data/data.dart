List<List<int>> grid = List.generate(9, (index) => [1, 2, 9, 7, 5, 6, 3, 8, 4]..shuffle());

class GridItems {
  int? _number;
  final Set<int> _centerPencilMarks = {};
  final Set<int> _cornerPencilMarks = {};

  set number(int num) => _number;
  set addCenterPencilMark(int num) => _centerPencilMarks.add(num);
  set addCornerPencilMark(int num) => _cornerPencilMarks.add(num);
}
