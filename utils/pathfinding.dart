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
  String toString() => '$loc \$$f $g';
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

    start
      ..g = 0
      ..h = _calculateHeuristic(start, goal)
      ..f = start.g + start.h;
    openSet.add(start);

    while (openSet.isNotEmpty) {
      // Find node with lowest f cost
      var current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if (current == goal) {
        //goal.g = current.g; // Make sure goal has correct cost
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // Check all neighbors
      for (final dir in directions) {
        var neighborPos = Point(
          current.loc.row + dir[0], // row first
          current.loc.col + dir[1], // then column
        );

        // Within grid and walkable.
        if (!grid.isValidPosition(neighborPos)) continue;
        if (!grid.isWalkable(neighborPos)) continue;
        if (!grid.isTraversable(current.loc, neighborPos)) continue;

        var neighbor = Node(neighborPos);

        // Skip if already evaluated
        if (closedSet.contains(neighbor)) continue;

        // Calculate cost to move to neighbor (g score)
        var moveCost = grid.costToMove(current.loc, neighbor.loc);
        var tentativeG = current.g + moveCost;

        var existingNeighbor = openSet.lookup(neighbor);
        if (existingNeighbor != null) {
          if (tentativeG >= existingNeighbor.g) continue;
          neighbor = existingNeighbor;
        } else {
          openSet.add(neighbor);
        }

        // Update neighbor with new costs
        neighbor.parent = current
          ..g = tentativeG
          ..h = _calculateHeuristic(neighbor, goal)
          ..f = neighbor.g + neighbor.h;
      }
    }

    return null; // No path found
  }

  List<List<Node>> findAllOptimalPaths(Node start, Node goal) {
    final openSet = <Node>{};
    final closedSet = <Node>{};
    final optimalPaths = <List<Node>>[];
    var optimalCost = double.infinity;

    start
      ..g = 0
      ..h = _calculateHeuristic(start, goal)
      ..f = start.g + start.h;
    openSet.add(start);

    while (openSet.isNotEmpty) {
      var current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if (current == goal) {
        final path = _reconstructPath(current);
        final pathCost = current.g;

        if (pathCost < optimalCost) {
          // Found a better path, clear previous paths
          optimalPaths.clear();
          optimalCost = pathCost;
          optimalPaths.add(path);
        } else if (pathCost == optimalCost) {
          // Found another path with same cost
          optimalPaths.add(path);
        }
        // Continue searching for other paths
        openSet.remove(current);
        closedSet.add(current);
        continue;
      }

      openSet.remove(current);
      closedSet.add(current);

      for (final dir in directions) {
        final neighborPos =
            Point(current.loc.row + dir[0], current.loc.col + dir[1]);

        if (!grid.isValidPosition(neighborPos)) continue;
        if (!grid.isWalkable(neighborPos)) continue;
        if (!grid.isTraversable(current.loc, neighborPos)) continue;

        var neighbor = Node(neighborPos);
        if (closedSet.contains(neighbor)) continue;

        final moveCost = grid.costToMove(current.loc, neighborPos);
        final tentativeG = current.g + moveCost;

        // Only consider paths that could be optimal
        if (tentativeG + _calculateHeuristic(neighbor, goal) > optimalCost) {
          continue;
        }

        final existingNeighbor = openSet.lookup(neighbor);
        if (existingNeighbor != null) {
          if (tentativeG > existingNeighbor.g) continue;
          // Equal cost path - create new node to track alternate path
          if (tentativeG == existingNeighbor.g) {
            neighbor = Node(neighborPos);
          } else {
            neighbor = existingNeighbor;
          }
        }

        neighbor
          ..parent = current
          ..g = tentativeG
          ..h = _calculateHeuristic(neighbor, goal)
          ..f = neighbor.g + neighbor.h;

        if (existingNeighbor == null) {
          openSet.add(neighbor);
        }
      }
    }

    return optimalPaths;
  }

  List<List<Point>> findAllPaths(Point start, Point goal) {
    final allPaths = <List<Point>>[];
    final visited = <Point>{};
    final currentPath = <Point>[];

    void dfs(Point current) {
      // Add current position to path and visited set
      currentPath.add(current);
      visited.add(current);

      // If we reached the goal, save this path
      if (current == goal) {
        allPaths.add(List.from(currentPath));
      } else {
        // Try all possible directions
        for (final dir in directions) {
          final next = Point(current.row + dir[0], current.col + dir[1]);

          // Check if move is legal
          if (grid.isValidPosition(next) &&
              grid.isWalkable(next) &&
              grid.isTraversable(current, next) &&
              !visited.contains(next)) {
            dfs(next);
          }
        }
      }

      // Backtrack: remove current position from path and visited set
      currentPath.removeLast();
      visited.remove(current);
    }

    // Start the search
    dfs(start);
    return allPaths;
  }

  double _calculateHeuristic(Node node, Node goal) {
    // Manhattan distance multiplied by minimum possible move cost
    // This ensures the heuristic is admissible
    final minCost = grid.getMinimumMoveCost();
    return node.loc.manhattanDistance(goal.loc) * minCost;
  }

  double getPathCost(List<Node> path) {
    return path.last.g; // The last node contains total cost from start
  }

  List<Node> _reconstructPath(Node node) {
    final path = <Node>[];
    var current = node;

    while (current.parent != null) {
      // Create new node to avoid reference issues
      final pathNode = Node(current.loc)
        ..g = current.g
        ..h = current.h
        ..f = current.f
        ..parent = current.parent;
      path.add(pathNode);
      current = current.parent!;
    }
    // Add start node
    path.add(
      Node(current.loc)
        ..g = current.g
        ..h = current.h
        ..f = current.f,
    );

    return path.reversed.toList();
  }
}
