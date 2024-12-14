import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/point.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  final customCellTypes = <CellType>[];

  @override
  Grid2D parseInput() {
    for (var i = 65; i <= 90; i++) {
      String letter = String.fromCharCode(i);
      var c = CellType(letter, letter, CellBehavior.clear, value: 0);
      customCellTypes.add(c);
    }

    return Grid2D.fromString(
      input.asString,
      customCellTypes,
    );
  }

  int countEdges(Grid2D grid, Region region) {
    var count = 0;

    for (final r in region.members) {
      final neighbors = grid.getNeighbors(r.loc);

      // count out of bounds
      count += 4 - neighbors.length;

      // now count up the non in group
      for (final n in neighbors) {
        var cell = grid.getAtPoint(n);
        if (cell.symbol != r.symbol) {
          // really wan thtis => region.members.contains(n) == false) {
          count++;
        }
      }
    }
    return count;
  }

  @override
  int solvePart1() {
    var sum = 0;

    final grid = parseInput();

    print(grid.toStringWithCoordinates());

    final regions = grid.findRegions(grid);

    // Print regions
    regions.forEach((symbol, region) {
      if (region.length == 1) {
        print('Region $symbol:');
      } else {
        print('Region $symbol has ${region.length} regions: ');
      }

      for (final r in region) {
        print('  Members: ${r.members.length}');
        print('  Edges: ${countEdges(grid, r)}');

        sum += (r.members.length * countEdges(grid, r));
      }
    });

    return sum;
  }

  @override
  int solvePart2() {
    var sum = 0;

    final grid = parseInput();

    print(grid.toStringWithCoordinates());

    final regions = grid.findRegions(grid);

    // Print regions
    regions.forEach((symbol, region) {
      if (region.length == 1) {
        print('Region $symbol:');
      } else {
        print('Region $symbol has ${region.length} regions: ');
      }

      for (final r in region) {
        print('  Members: ${r.members.length}');
        print('  Edges: ${countEdges(grid, r)}');

        sum += (r.members.length * countEdges(grid, r));
      }
    });

    return sum;
  }
}
