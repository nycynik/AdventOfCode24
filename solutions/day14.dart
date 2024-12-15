import 'package:image/image.dart' as img;
import 'dart:io';

import '../utils/index.dart';
import '../utils/point.dart';

class VisualizationOptions {
  final int scale;
  final img.Color backgroundColor;
  final img.Color robotColor;
  final bool drawGrid;

  VisualizationOptions({
    this.scale = 2,
    img.Color? backgroundColor,
    img.Color? robotColor,
    this.drawGrid = false,
  })  : backgroundColor = backgroundColor ?? img.ColorRgb8(0, 0, 0),
        robotColor = robotColor ?? img.ColorRgb8(0, 255, 0);
}

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
  late img.BitmapFont font;

  Day14() : super(14) {
    // font

    // String fontData = File('fonts/operius.fnt').readAsStringSync();
    // var fontImage = img.decodePng(File('fonts/operius_0.png').readAsBytesSync());

    // font = img.BitmapFont.fromFnt(fontData, fontImage!);
  }

  Future<void> saveRobotPositions(List<Robotic> robots, int stepNumber, VisualizationOptions options) async {
    if (stepNumber < 6400 || stepNumber > 6500) return;
    final imageWidth = width * options.scale;
    final imageHeight = height * options.scale;

    var image = img.Image(width: imageWidth, height: imageHeight);
    img.fill(image, color: options.backgroundColor);

    if (options.drawGrid) {
      for (var x = 0; x < width; x++) {
        for (var y = 0; y < height; y++) {
          img.drawPixel(image, x * options.scale, y * options.scale, img.ColorRgb8(20, 20, 20));
        }
      }
    }

    // Draw robots
    for (var robot in robots) {
      var x = robot.location.col * options.scale;
      var y = robot.location.row * options.scale;

      // Draw a scaled pixel square for each robot
      for (var dx = 0; dx < options.scale; dx++) {
        for (var dy = 0; dy < options.scale; dy++) {
          img.drawPixel(image, x + dx, y + dy, options.robotColor);
          img.drawPixel(image, x + dx + 1, y + dy, options.robotColor);
          img.drawPixel(image, x + dx + 1, y + dy + 1, options.robotColor);
          img.drawPixel(image, x + dx, y + dy + 1, options.robotColor);
        }
      }
    }

    //img.drawString(image, 'Step $stepNumber', color: img.ColorRgb8(128, 255, 64), x: 5, y: 5, font: this.font);

    final filename = 'robot_positions_${stepNumber.toString().padLeft(5, '0')}.png';
    File('images/$filename').writeAsBytesSync(img.encodePng(image));
  }

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
    var robots = parseInput();
    var maxSteps = 10000;

    final visualOptions = VisualizationOptions(
      scale: 4, // Larger pixels
      backgroundColor: img.ColorRgb8(0, 0, 0),
      robotColor: img.ColorRgb8(0, 255, 0),
      drawGrid: true,
    );

    for (int step = 0; step < maxSteps; step++) {
      for (var robot in robots) {
        robot.location = Point(
            (robot.location.row * robot.velocity.row) % width, (robot.location.col * robot.velocity.col) % height);
      }
      saveRobotPositions(robots, step, visualOptions);
    }

    return 0;
  }
}
