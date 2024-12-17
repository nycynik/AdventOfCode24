import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/robot/movementBahavior.dart';
import '../utils/robot/robot.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  final customCellTypes = [
    CellType('.', 'Empty space', CellBehavior.clear),
    CellType('#', 'Wall', CellBehavior.blocking),
    CellType('O', 'Bolder', CellBehavior.pushable),
    CellType('[', 'LeftBolder', CellBehavior.pushable),
    CellType(']', 'RightBolder', CellBehavior.pushable),
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
      if (startReading) commands += line.trim();
    }

    return (grid, commands);
  }

  (Grid2D, String) parseInputPart2() {
    final lines = input.getPerLine();
    var gridData = <String>[];
    for (var line in lines) {
      if (line.trim().isEmpty) break;
      var widerLine = line.replaceAll('#', '##').replaceAll('O', '[]').replaceAll('.', '..').replaceAll('@', '@.');
      gridData.add(widerLine);
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
      if (startReading) commands += line.trim();
    }

    return (grid, commands);
  }

  @override
  int solvePart1() {
    var data = parseInput();
    var grid = data.$1;
    var commands = data.$2;

    var robot =
        Robot(facing: Direction.up, grid: grid, movementBehavior: FreeMovementBehavior(), cellTypes: customCellTypes);

    print(robot.grid.toStringWithCoordinates());
    for (final command in commands.split('')) {
      var directionToMove = Direction.up;
      switch (command) {
        case '^':
          directionToMove = Direction.up;
          break;
        case 'v':
          directionToMove = Direction.down;
          break;
        case '<':
          directionToMove = Direction.left;
          break;
        case '>':
          directionToMove = Direction.right;
          break;
      }

      // when I move you move,
      // var previous_pos = robot.position;
      robot.moveInDirection(directionToMove);
      // if (previous_pos == robot.position) {
      //   print("Robot is blocked from moving ${directionToMove} ");
      // } else {
      //   print("Robot moved ${directionToMove} to ${robot.position}");
      // }
    }

    print(robot.grid.toStringWithCoordinates());

    int sum = 0;
    var allPushables = robot.grid.findCellBehaviorsOnGrid(CellBehavior.pushable);
    for (final block in allPushables) {
      sum += block.row * 100 + block.col;
    }
    return sum;
  }

  @override
  int solvePart2() {
    var data = parseInputPart2();
    var grid = data.$1;
    var commands = data.$2;

    var robot =
        Robot(facing: Direction.up, grid: grid, movementBehavior: FreeMovementBehavior(), cellTypes: customCellTypes);

    print(robot.grid.toStringWithCoordinates());
    return 0;
  }
}
