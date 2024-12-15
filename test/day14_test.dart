// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day14.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = '''
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
// const _exampleInput2 = _exampleInput1;
const _exampleInput2 = '''
''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 12;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 0;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = null;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = null;

void main() {
  group(
    'Day 14 - Example Input',
    () {
      test('Part 1', () {
        final day = Day14()..inputForTesting = _exampleInput1;
        expect(day.solvePart1Small(), _exampleSolutionPart1);
      });
      test('Part 2', () {
        final day = Day14()..inputForTesting = _exampleInput2;
        expect(day.solvePart2(), _exampleSolutionPart2);
      });
    },
  );
  group(
    'Day 14 - Puzzle Input',
    () {
      final day = Day14();
      test(
        'Part 1',
        skip: _puzzleSolutionPart1 == null ? 'Skipped because _puzzleSolutionPart1 is null' : false,
        () => expect(day.solvePart1(), _puzzleSolutionPart1),
      );
      test(
        'Part 2',
        skip: _puzzleSolutionPart2 == null ? 'Skipped because _puzzleSolutionPart2 is null' : false,
        () => expect(day.solvePart2(), _puzzleSolutionPart2),
      );
    },
  );
}
