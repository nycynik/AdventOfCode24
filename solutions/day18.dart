import 'package:test/test.dart';

import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfinding.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/point.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  int gridSize = 70;
  int maxSteps = 1024;

  final customCellTypes = [
    CellType('.', 'Empty space', CellBehavior.clear),
    CellType('#', 'Wall', CellBehavior.blocking),
  ];

  @override
  List<Point> parseInput() {
    var dropPoints = <Point>[];
    var lines = input.getPerLine();

    for (final line in lines) {
      if (line.isEmpty) continue;
      dropPoints.add(Point.fromStringXY(line));
    }
    return dropPoints;
  }

  List<Point> convertNodesToPoints(List<Node> nodes) {
    var points = <Point>[];
    for (final node in nodes) {
      points.add(node.loc);
    }
    return points;
  }

  @override
  int solvePart1() {
    var steps = 0;

    var droppingBlocks = parseInput();

    if (droppingBlocks.length < 30) {
      gridSize = 7;
      maxSteps = 12;
    }
    maxSteps--; // fixing counting from 0

    var grid = Grid2D.filledGrid(gridSize, gridSize, CellType('.', '.', CellBehavior.clear), customCellTypes);

    for (var x = 0; x < droppingBlocks.length; x++) {
      var block = droppingBlocks[x];
      grid.setAtPoint(block, CellType('#', '#', CellBehavior.blocking));

      var astar = AStar(grid);
      var path = astar.findOptimalPath(Node(Point(0, 0)), Node(Point(gridSize - 1, gridSize - 1)));
      if (path.length > 0) {
        steps = path.length - 1; // -1 since you don't walk to start.
        if (steps > 0) {
          //== 438) {
          List<Point> pathPoints = convertNodesToPoints(path);
          // clear \x1B[2J
          // print("\x1B[0;0H");
          // print('${x + 1}: path has $steps');
          // print(grid.toStringWithCoordinates(path: pathPoints));
        } else {
          // print('no path found');
          // print(grid.toStringWithCoordinates());
        }
      }
      //if (x >= maxSteps) break;
    }

    print(grid.toStringWithCoordinates());
    return steps;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
