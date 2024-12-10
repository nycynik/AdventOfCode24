import 'pathfindingGrid.dart';
import 'point.dart';

class Node {
  final Point loc;
  double f = 0; // total cost (g + h)
  double g = 0; // cost from start to this node
  double h = 0; // heuristic (estimated cost to goal)
  Node? parent;

  Node(this.loc);

  @override
  bool operator ==(Object other) => other is Node && loc == other.loc;

  @override
  int get hashCode => Object.hash(loc.col, loc.row);

  @override
  String toString() => '$loc \$$f';
}

class AStar {
  final PathfindingGrid grid;
  final List<List<int>> directions = [
    [-1, 0], // up
    [1, 0], // down
    [0, -1], // left
    [0, 1], // right
  ];

  AStar(this.grid);

  List<Node>? findPath(Node start, Node goal) {
    var openSet = <Node>{};
    var closedSet = <Node>{};

    openSet.add(start);

    while (openSet.isNotEmpty) {
      // Find node with lowest f cost
      var current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if (current == goal) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // Check all neighbors
      for (var dir in directions) {
        var neightbor =
            Node(Point(current.loc.col + dir[0], current.loc.row + dir[1]));

        // Check if position is within grid bounds
        if (!grid.isValidPosition(neightbor.loc)) continue;

        // Check if position is walkable
        if (!grid.isWalkable(neightbor.loc)) continue;

        var neighbor = Node(neightbor.loc);

        // Skip if already evaluated
        if (closedSet.contains(neighbor)) continue;

        // Calculate g score
        var tentativeG =
            current.g + 1; // Assuming cost of 1 to move to adjacent square

        var isNewNode = !openSet.contains(neighbor);
        if (isNewNode) {
          openSet.add(neighbor);
        } else if (tentativeG >= neighbor.g) {
          continue; // This is not a better path
        }

        // This path is the best until now. Record it!
        neighbor.parent = current
          ..g = tentativeG
          ..h = _calculateHeuristic(neighbor, goal)
          ..f = neighbor.g + neighbor.h;
      }
    }

    return null; // No path found
  }

  double _calculateHeuristic(Node node, Node goal) {
    // Manhattan distance
    return node.loc.manhattanDistance(goal.loc).toDouble();
  }

  List<Node> _reconstructPath(Node node) {
    var path = <Node>[];
    var current = node;

    while (current.parent != null) {
      path.add(current);
      current = current.parent!;
    }
    path.add(current); // Add start node

    return path.reversed.toList();
  }
}
