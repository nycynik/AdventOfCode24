import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfinding.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/point.dart';
import '../utils/robot/robot.dart';
import '../utils/sparseGrid.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<List<int>> parseInput() {
    final locations = input.getPerLine();

    final left = <int>[];
    final right = <int>[];

    for (var x = 0; x < locations.length; x++) {
      // split location into two numbers, and sum them
      final location = locations[x].split('   ');
      if (location.length < 2) continue;
      left.add(int.parse(location[0]));
      right.add(int.parse(location[location.length - 1]));
    }
    left.sort();
    right.sort();
    return [left, right];
  }

  @override
  int solvePart1() {
    final totals = parseInput();
    var totalDiff = 0;

    for (var x = 0; x < totals[0].length; x++) {
      totalDiff += (totals[1][x] - totals[0][x]).abs();
    }

    // // Create from raw strings
    // final customCellTypes = [
    //   const CellType('^', 'Start', CellBehavior.start),
    //   const CellType(r'$', 'Goal', CellBehavior.goal),
    // ];

    // // Create a grid with custom types
    // var grid = Grid2D.fromStrings([
    //   '...#.',
    //   '.#..^',
    //   '.....',
    //   r'#...$',
    //   '.....',
    // ], customCellTypes);

    // final r = Robot(
    //   facing: Direction.right,
    //   grid: grid,
    //   initialPosition: const Point(0, 0),
    //   cellTypes: customCellTypes,
    // );

    // if (r.canMoveToPosition(const Point(4, 4))) {
    //   print('Reached goal!');
    // }

    // // Print the grid
    // print(r.getPathMap(withCoordinates: true));

    return totalDiff;
  }

  @override
  int solvePart2() {
    final totals = parseInput();
    var totalDiff = 0;

    for (var x = 0; x < totals[0].length; x++) {
      final leftVal = totals[0][x];
      // count occurances of leftVal in totals[1]
      final countOfRight =
          totals[1].where((number) => number == leftVal).length;

      final similarityScore = leftVal * countOfRight;
      totalDiff += similarityScore;
    }

    return totalDiff;
  }
}
