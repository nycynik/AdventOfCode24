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

  @override
  int solvePart1() {
    var robots = parseInput();

    for (var robot in robots) {
      print(robot);
    }
    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
