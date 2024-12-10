import 'pathfindingGrid.dart';
import 'point.dart';

class SparseGrid implements PathfindingGrid {
  final Set<Point> _obstacles;
  final int maxX;
  final int maxY;
  final List<CellType> _supportedCellTypes;

  SparseGrid({
    required Set<Point> obstacles,
    required this.maxX,
    required this.maxY,
    required List<CellType> customTypes,
  })  : _obstacles = obstacles,
        _supportedCellTypes = [
          BaseGrid.empty,
          BaseGrid.blocked,
          ...customTypes
        ] {
    validateCellTypes();
  }

  // Factory constructor to create from a list of strings
  factory SparseGrid.fromStrings(List<String> lines) {
    var obstacles = <Point>{};
    var maxY = lines.first.length;
    var maxX = lines.length;

    for (var row = 0; row < lines.length; row++) {
      for (var col = 0; col < lines[row].length; col++) {
        if (lines[row][col] == '#') {
          // or whatever represents an obstacle
          obstacles.add(Point(row, col));
        }
      }
    }

    return SparseGrid(
      obstacles: obstacles,
      maxX: maxX,
      maxY: maxY,
      customTypes: [], // Add custom types if needed
    );
  }

  @override
  CellType operator [](Point p) {
    if (!isValidPosition(p)) {
      throw RangeError('Position $p is out of bounds');
    }
    return _obstacles.contains(p) ? BaseGrid.blocked : BaseGrid.empty;
  }

  @override
  int get length => maxX;

  @override
  int get width => maxY;

  @override
  bool isValidPosition(Point p) {
    return p.row >= 0 && p.row < length && p.col >= 0 && p.col < width;
  }

  @override
  List<CellType> get supportedCellTypes => _supportedCellTypes;

  // Helper method to check if a position is walkable (not blocked)
  bool isWalkable(Point p) {
    return isValidPosition(p) && !_obstacles.contains(p);
  }

  // Method to add an obstacle
  void addObstacle(Point p) {
    if (isValidPosition(p)) {
      _obstacles.add(p);
    }
  }

  // Method to remove an obstacle
  void removeObstacle(Point p) {
    _obstacles.remove(p);
  }

  // Method to get all obstacles
  Set<Point> get obstacles => Set.unmodifiable(_obstacles);

  // Optional: Method to get neighbors for pathfinding
  List<Point> getNeighbors(Point p) {
    final directions = [
      Point(-1, 0), // up
      Point(1, 0), // down
      Point(0, -1), // left
      Point(0, 1), // right
    ];

    return directions
        .map((dir) => Point(p.row + dir.row, p.col + dir.col))
        .where((pos) => isValidPosition(pos) && isWalkable(pos))
        .toList();
  }

  @override
  String toString() {
    var buffer = StringBuffer();
    for (var row = 0; row < maxX; row++) {
      for (var col = 0; col < maxY; col++) {
        final point = Point(row, col);
        buffer.write(_obstacles.contains(point) ? '#' : '.');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  @override
  int get cols => length;

  @override
  int get rows => width;

  @override
  void validateCellTypes() {
    return;
  }
}
