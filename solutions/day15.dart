import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/robot.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  final customCellTypes = [
    CellType('.', 'Empty space', CellBehavior.clear),
    CellType('#', 'Wall', CellBehavior.blocking),
    CellType('O', 'Bolder', CellBehavior.movable),
    CellType('@', 'Start', CellBehavior.start),
  ];

  @override
  (Grid2D, String) parseInput() {
    final lines = input.getPerLine();
    var gridData = <String>[];
    for (var line in lines) {
      if (line.trim().isEmpty) break;
      gridData.add(line);
    }
    var grid = Grid2D.fromStrings(gridData, customCellTypes);

    // now read the commands, into one string
    String commands = "";
    var startReading = false;
    for (var line in lines) {
      if (line.trim().isEmpty) {
        startReading = true;
        continue;
      }
      if (startReading) commands += line;
    }

    return (grid, commands);
  }

  @override
  int solvePart1() {
    var data = parseInput();
    var grid = data.$1;
    var commands = data.$2;

    print(grid.toStringWithCoordinates());

    var freeMovingRobot =
        Robot(facing: Direction.up, grid: grid, movementBehavior: FreeMovementBehavior(), cellTypes: customCellTypes);

    for (final command in commands.split('')) {
      switch (command) {
        case '^':
          freeMovingRobot.moveInDirection(Direction.up);
          break;
        case 'v':
          freeMovingRobot.moveInDirection(Direction.down);
          break;
        case '<':
          freeMovingRobot.moveInDirection(Direction.left);
          break;
        case '>':
          freeMovingRobot.moveInDirection(Direction.right);
          break;
      }
      print(grid.toStringWithCoordinates());
    }
    return 0;
  }

  @override
  int solvePart2() {
    var data = parseInput();
    var grid = data.$1;
    var commands = data.$2;

    return 0;
  }
}
