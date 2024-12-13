import '../utils/index.dart';

typedef XYCombo = (int x, int y);

class ClawMachine {
  XYCombo buttonA;
  XYCombo buttonB;
  XYCombo prizeLocation;
  (int a, int b) _tokenCost;

  ClawMachine(this.buttonA, this.buttonB, this.prizeLocation) : _tokenCost = (0, 0);

  @override
  String toString() {
    return 'ClawMachine(buttonA: $buttonA, buttonB: $buttonB, prizeLocation: $prizeLocation)';
  }

  // Getter
  (int a, int b) get tokenCost => _tokenCost;

  // Setter
  set tokenCost((int a, int b) value) {
    _tokenCost = value;
  }

  /// Solves the claw machine problem for the given setup.
  /// Returns a map containing the solution and cost.
  Map<String, dynamic> solve() {
    final aX = buttonA.$1;
    final aY = buttonA.$2;
    final bX = buttonB.$1;
    final bY = buttonB.$2;
    final goalX = prizeLocation.$1;
    final goalY = prizeLocation.$2;

    // Solve linear Diophantine equations
    final solution = _solveDiophantine(aX, bX, goalX, aY, bY, goalY);

    if (solution == null) {
      return {'isPossible': false};
    }

    final nA = solution[0];
    final nB = solution[1];
    final cost = _tokenCost.$1 * nA + _tokenCost.$2 * nB;
    final ta = nA * aX + nB * bX;
    final tb = nB * bY + nA * aY;

    if (ta != goalX || tb != goalY) {
      return {'isPossible': false};
    }

    return {
      'isPossible': true,
      'nA': nA,
      'nB': nB,
      'totalCost': cost,
      'final': '$ta, $tb',
    };
  }

  /// Solves two linear Diophantine equations to find nA and nB.
  /// Returns a list [nA, nB] or null if no solution exists.
  /// see https://en.wikipedia.org/wiki/Diophantine_equation
  /// and https://docs.sympy.org/latest/modules/solvers/diophantine.html
  List<int>? _solveDiophantine(int aX, int bX, int goalX, int aY, int bY, int goalY) {
    // Use integer linear algebra to find a solution
    final det = aX * bY - aY * bX;

    if (det == 0) {
      // Parallel lines, no unique solution
      return null;
    }

    // Particular solution using Cramer's rule
    final nA = (goalX * bY - goalY * bX) ~/ det;
    final nB = (aX * goalY - aY * goalX) ~/ det;

    if (nA < 0 || nB < 0) {
      // Non-negative integer solution not possible
      return null;
    }

    return [nA, nB];
  }
}

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<ClawMachine> parseInput() {
    List<ClawMachine> clawMachines = [];

    final lines = input.getPerLine();
    var buttonA = (0, 0);
    var buttonB = (0, 0);

    for (final line in lines) {
      if (line.length == 0) continue;
      final parts = line.trim().split(':');
      final part2 = parts[1].trim().split(', ');

      switch (parts[0]) {
        case 'Button A':
          buttonA = (int.parse(part2[0].substring(2).trim()), int.parse(part2[1].substring(2).trim()));
          break;
        case 'Button B':
          buttonB = (int.parse(part2[0].substring(2).trim()), int.parse(part2[1].substring(2).trim()));
          break;
        case 'Prize':
          parts[0] = '2';
          final prizeLocation = (int.parse(part2[0].substring(2).trim()), int.parse(part2[1].substring(2).trim()));
          clawMachines.add(ClawMachine(buttonA, buttonB, prizeLocation));
          break;
        default:
          break;
      }
    }
    return clawMachines;
  }

  @override
  List<ClawMachine> parseInput2() {
    List<ClawMachine> clawMachines = [];

    final lines = input.getPerLine();
    var buttonA = (0, 0);
    var buttonB = (0, 0);

    for (final line in lines) {
      if (line.length == 0) continue;
      final parts = line.trim().split(':');
      final part2 = parts[1].trim().split(', ');

      switch (parts[0]) {
        case 'Button A':
          buttonA = (int.parse(part2[0].substring(2).trim()), int.parse(part2[1].substring(2).trim()));
          break;
        case 'Button B':
          buttonB = (int.parse(part2[0].substring(2).trim()), int.parse(part2[1].substring(2).trim()));
          break;
        case 'Prize':
          parts[0] = '2';
          final prizeLocation = (
            10000000000000 + int.parse(part2[0].substring(2).trim()),
            10000000000000 + int.parse(part2[1].substring(2).trim())
          );
          clawMachines.add(ClawMachine(buttonA, buttonB, prizeLocation));
          break;
        default:
          break;
      }
    }
    return clawMachines;
  }

  @override
  int solvePart1() {
    var tokenCost = (3, 1);
    var clawMachines = parseInput();
    //update tokencost
    for (final m in clawMachines) {
      m.tokenCost = tokenCost;
    }

    num totalTokens = 0;
    for (final clawMachine in clawMachines) {
      final result = clawMachine.solve();
      if (result.containsKey('isPossible') && result['isPossible'] == true) {
        var cost = int.parse(result['totalCost'].toString());
        var solutionA = int.parse(result['nA'].toString());
        var solutionB = int.parse(result['nB'].toString());

        print('Solution Found! for $clawMachine');
        print('nA: ${result['nA']}, nB: ${result['nB']} yields ${result['final']}');
        print('Total Cost: $cost');
        totalTokens += cost;
      } else {
        print('No solution is possible.');
      }
    }
    return totalTokens.toInt();
  }

  @override
  int solvePart2() {
    var tokenCost = (3, 1);
    var clawMachines = parseInput2();
    //update tokencost
    for (final m in clawMachines) {
      m.tokenCost = tokenCost;
    }

    num totalTokens = 0;
    for (final clawMachine in clawMachines) {
      final result = clawMachine.solve();
      if (result.containsKey('isPossible') && result['isPossible'] == true) {
        var cost = int.parse(result['totalCost'].toString());
        var solutionA = int.parse(result['nA'].toString());
        var solutionB = int.parse(result['nB'].toString());

        print('Solution Found! for $clawMachine');
        print('nA: ${result['nA']}, nB: ${result['nB']} yields ${result['final']}');
        print('Total Cost: $cost');
        totalTokens += cost;
      } else {
        print('No solution is possible.');
      }
    }
    return totalTokens.toInt();
  }
}
