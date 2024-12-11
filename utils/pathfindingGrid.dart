// CellTypes - what the robot thinks the grid pos is.
import 'point.dart';

class CellType {
  final String symbol;
  final num value;
  final String description;
  final CellBehavior behavior;

  const CellType(this.symbol, this.description, this.behavior,
      {this.value = 0});

  // simple quick constructor, for from lists and such.
  factory CellType.fromChar(String char) {
    return CellType(char, '', CellBehavior.unknown);
  }

  @override
  String toString() {
    return symbol;
  }

  // copy
  CellType copy() {
    return CellType(symbol, description, behavior);
  }
}

enum CellBehavior { clear, blocking, start, goal, unknown }

abstract class BaseGrid {
  // Minimum required CellTypes that all grids must support
  static const CellType empty =
      CellType('.', 'Empty space', CellBehavior.clear);
  static const CellType blocked =
      CellType('#', 'Obstacle', CellBehavior.blocking);

  // Getter for all supported cell types
  List<CellType> get supportedCellTypes;

  // Helper method to validate cell types
  void validateCellTypes() {
    if (!supportedCellTypes.contains(empty)) {
      throw StateError('Grid must support empty cell type');
    }
    if (!supportedCellTypes.contains(blocked)) {
      throw StateError('Grid must support blocked cell type');
    }
  }
}

// abc for pathfinding in 2D grids
abstract class PathfindingGrid extends BaseGrid {
  int get length; // height/rows
  int get rows => length;
  int get width; // width/columns
  int get cols => width;
  CellType operator [](Point position); // what is at position
  bool isValidPosition(Point position); // is in bounds?

  bool isWalkable(Point p) {
    return isValidPosition(p) && this[p].behavior != CellBehavior.blocking;
  }

  bool isTraversable(Point start, Point dest) {
    return isWalkable(start) && isWalkable(dest);
  }

  double costToMove(Point from, Point to) {
    // Your custom cost function here
    // For example, based on height differences:
    // var heightDiff = (getHeight(to) - getHeight(from)).abs();
    //     return (this[from].value - this[to].value).abs();
    return 1.0;
  }

  double getMinimumMoveCost() {
    // Return the minimum possible cost for any move
    // This is important for the heuristic to remain admissible
    return 1.0; // or whatever your minimum cost would be
  }
}