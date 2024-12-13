import '../utils/grid2D.dart';
import '../utils/pathfindingGrid.dart';
import '../utils/point.dart';
import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  final customCellTypes = [
    CellType('.', 'Empty space', CellBehavior.clear),
    CellType('#', 'Obstical', CellBehavior.blocking),
    CellType('^', 'Start', CellBehavior.start),
  ];
    
  @override
  Grid2D parseInput() {
    return Grid2D.fromString(
      input.asString,
      customCellTypes,
      ignoreTypes: true,
    );
  }

  @override
  int solvePart1() {
    var grid = parseInput();
    var antinodes = <Point>{};

    for (final character in grid.characters) {
      if (character != '.' && grid.getCharCount(character) >= 2) {
        // find all instances of the character in the grid
        final instances = grid.findSymbolsOnGrid(character);
        for (var x = 0; x < instances.length; x++) {
          for (var y = x + 1; y < instances.length; y++) {
            final antinode1 = instances[y] + (instances[y] - instances[x]);
            final antinode2 = instances[x] + (instances[x] - instances[y]);
            if (grid.isValidPoint(antinode1)) {
              antinodes.add(antinode1);
            }
            if (grid.isValidPoint(antinode2)) {
              antinodes.add(antinode2);
            }
          }
        }
      }
    }
    return antinodes.length;
  }

  @override
  int solvePart2() {
    var grid = parseInput();
    var antinodes = <Point>{};

    for (final character in grid.characters) {
      if (character != '.' && grid.getCharCount(character) >= 2) {
        // find all instances of the character in the grid
        final instances = grid.findSymbolsOnGrid(character);
        for (var x = 0; x < instances.length; x++) {
          for (var y = x + 1; y < instances.length; y++) {
            var startPosition = instances[y];
            while (true) {
              if (grid.isValidPoint(startPosition)) {
                antinodes.add(startPosition);
              } else {
                break;
              }
              startPosition = startPosition + (instances[y] - instances[x]);
            }
            startPosition = instances[x];
            while (true) {
              if (grid.isValidPoint(startPosition)) {
                antinodes.add(startPosition);
              } else {
                break;
              }
              startPosition = startPosition + (instances[x] - instances[y]);
            }
          }
        }
      }
    }
    return antinodes.length;
  }
}
