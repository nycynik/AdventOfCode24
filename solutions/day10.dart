import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfinding.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/robot.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  final customCellTypes = [
    CellType('0', 'Start', CellBehavior.start, value: 0),
    CellType('1', '1', CellBehavior.clear, value: 1),
    CellType('2', '2', CellBehavior.clear, value: 2),
    CellType('3', '3', CellBehavior.clear, value: 3),
    CellType('4', '4', CellBehavior.clear, value: 4),
    CellType('5', '5', CellBehavior.clear, value: 5),
    CellType('6', '6', CellBehavior.clear, value: 6),
    CellType('7', '7', CellBehavior.clear, value: 7),
    CellType('8', '8', CellBehavior.clear, value: 8),
    CellType('9', 'Goal', CellBehavior.goal, value: 9),
  ];

  @override
  Grid2D parseInput() {
    return Grid2D.fromString(
      input.asString,
      customCellTypes,
    );
  }

  @override
  int solvePart1() {
    var grid = parseInput();
    // print(grid.toStringWithCoordinates());
    // find all the 0s, the start cells
    var trailHeads = grid.findCellBehaviorsOnGrid(CellBehavior.start);

    // find all the 9s, the goal cells
    var peaks = grid.findCellBehaviorsOnGrid(CellBehavior.goal);

    // loop over all starts, and see if there is a path to all the peak
    // print('Searching ${trailHeads.length} trailheads to see if they can '
    //     'reach any of the ${peaks.length} peaks.');
    var totalTrailheadsThatReachPeaks = 0;
    for (final startPos in trailHeads) {
      var reachablePeaks = 0;
      for (final goalPos in peaks) {
        // build the robot explorer
        final explorer = Robot(
          facing: Direction.right,
          grid: grid,
          initialPosition: startPos,
          cellTypes: customCellTypes,
          maxIncrementPerMove: 1,
        );
        var path = explorer.getPathToPosition(goalPos);
        if (path != null) {
          //print(path);
          totalTrailheadsThatReachPeaks++;
          reachablePeaks++;
          //print('path length ${path.length} path cost ${path[0].g}');
          //print('Trailhead at $startPos can reach peak at $goalPos');
        }
      }
      //print('Trailhead at $startPos can reach $reachablePeaks peaks');
    }
    return totalTrailheadsThatReachPeaks;
  }

  @override
  int solvePart2() {
    var grid = parseInput();

    // find all the 0s, the start cells
    var trailHeads = grid.findCellBehaviorsOnGrid(CellBehavior.start);

    // find all the 9s, the goal cells
    var peaks = grid.findCellBehaviorsOnGrid(CellBehavior.goal);

    var totalTrailheadsThatReachPeaks = 0;
    for (final startPos in trailHeads) {
      for (final goalPos in peaks) {
        var astar = AStar(grid);
        var allPaths = astar.findAllPaths(startPos, goalPos);
        if (allPaths.length > 0) {
          totalTrailheadsThatReachPeaks += allPaths.length;
          //print('Trailhead at $startPos can reach peak at $goalPos');
        }
      }
    }

    return totalTrailheadsThatReachPeaks;
  }
}
