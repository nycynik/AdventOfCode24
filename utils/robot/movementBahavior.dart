/* robot movement behaviour */
import '../grid2D.dart';
import '../point.dart';
import 'robot.dart';

abstract class MovementBehavior {
  bool moveInDirection(Robot robot, Direction direction);
  bool canMoveInDirection(Robot robot, Direction direction);
  Point getNextPosition(Robot robot, Direction direction);
}

// Implementation for robots that need to face a direction before moving
class FacingMovementBehavior implements MovementBehavior {
  @override
  bool moveInDirection(Robot robot, Direction direction) {
    // If not facing the right direction, return false
    if (robot.facing != direction) {
      return false;
    }

    final nextPosition = getNextPosition(robot, direction);
    if (robot.canMoveTo(nextPosition, direction)) {
      robot.setRobotPosition(nextPosition, direction);
      return true;
    }
    return false;
  }

  @override
  bool canMoveInDirection(Robot robot, Direction direction) {
    return robot.facing == direction && robot.canMoveTo(getNextPosition(robot, direction), direction);
  }

  @override
  Point getNextPosition(Robot robot, Direction direction) {
    return robot.position.move(direction);
  }
}

// Implementation for robots that can move in any direction
class FreeMovementBehavior implements MovementBehavior {
  @override
  bool moveInDirection(Robot robot, Direction direction) {
    final nextPosition = getNextPosition(robot, direction);
    if (robot.canMoveTo(nextPosition, direction)) {
      robot.setRobotPosition(nextPosition, direction);
      return true;
    }
    return false;
  }

  @override
  bool canMoveInDirection(Robot robot, Direction direction) {
    return robot.canMoveTo(getNextPosition(robot, direction), direction);
  }

  @override
  Point getNextPosition(Robot robot, Direction direction) {
    return robot.position.move(direction);
  }
}
