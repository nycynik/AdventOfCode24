import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/point.dart';

class Robotic {
  Point location = Point(0, 0);
  Point velocity = Point(0, 0);

  Robotic(this.location, this.velocity);

  @override
  String toString() {
    return 'Robotic at $location with velocity $velocity';
  }
}

class Day14 extends GenericDay {
  int width = 101;
  int height = 103;

  Day14() : super(14);

  @override
  List<Robotic> parseInput() {
    var lines = input.getPerLine();
    var robots = <Robotic>[];

    for (final line in lines) {
      if (line.isEmpty) continue;

      var parts = line.trim().split(' ');

      var pos = parts[0].substring(2).split(',');
      var location = Point(int.parse(pos[0]), int.parse(pos[1]));

      var vel = parts[1].trim().substring(2).split(',');
      var velocity = Point(int.parse(vel[0]), int.parse(vel[1]));

      robots.add(Robotic(location, velocity));
    }
    return robots;
  }

  int getQuadrant(Point p, int width, int height) {
    int midrow = width ~/ 2;
    int midcol = height ~/ 2;
    if (p.row < midrow && p.col < midcol) return 1;
    if (p.row < midrow && p.col > midcol) return 2;
    if (p.row > midrow && p.col < midcol) return 3;
    if (p.row > midrow && p.col > midcol) return 4;
    return 0;
  }

  int solvePart1Small() {
    this.width = 11; // 101
    this.height = 7; // 103

    return this.solvePart1();
  }

  @override
  int solvePart1() {
    var robots = parseInput();

    var quadrantCounts = [0, 0, 0, 0, 0];

    for (var robot in robots) {
      robot.location = Point((robot.location.row + 100 * robot.velocity.row) % width,
          (robot.location.col + 100 * robot.velocity.col) % height);
      var quadrant = getQuadrant(robot.location, width, height);
      quadrantCounts[quadrant]++;
    }
    return quadrantCounts[1] * quadrantCounts[2] * quadrantCounts[3] * quadrantCounts[4];
  }

  @override
  int solvePart2() {
    return 0;
  }
}
