import '../utils/LRUCache.dart';
import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<String> parseInput() {
    return input.asString.trim().split(' ');
  }

  List<String> splitInHalf(String str) {
    return [str.substring(0, str.length ~/ 2), str.substring(str.length ~/ 2)];
  }

  List<String> blink(List<String> stones) {
    final newStones = <String>[];
    for (final stone in stones) {
      if (stone == '0') {
        newStones.add('1');
      } else {
        if (stone.length.isEven) {
          final splitstone = splitInHalf(stone);
          newStones
            ..add(BigInt.parse(splitstone[0]).toString())
            ..add(BigInt.parse(splitstone[1]).toString());
        } else {
          newStones.add((BigInt.parse(stone) * BigInt.from(2024)).toString());
        }
      }
    }
    return newStones;
  }

  int blinkTimes(String stone, int times, LRUCache<String, int> cache) {
    if (times == 0) return 1;
    // print('$stone, $times');
    var totalStones = 1;
    final cacheKey = '$stone|${times}';

    if (cache.has(cacheKey)) {
      return cache.get(cacheKey)!;
    }
    // no cache for me, so figure it out.
    var nextStones = [stone];

    for (var x = 0; x < times; x++) {
      nextStones = blink(nextStones);
      // print(nextStones);
      if (nextStones.length != 1) {
        totalStones =
            (blinkTimes(nextStones[0], times - x - 1, cache) + blinkTimes(nextStones[1], times - x - 1, cache));
        break;
      }
    }
    // print(' solved Stone: $stone key: $cacheKey stones: $totalStones');
    cache.set(cacheKey, totalStones);

    return totalStones;
  }

  @override
  int solvePart1() {
    var stones = parseInput();

    for (var x = 0; x < 25; x++) {
      stones = blink(stones);
    }
    return stones.length;
  }

  @override
  int solvePart2() {
    final cache = LRUCache<String, int>(25000);

    var stones = parseInput();
    var totalStones = 0;

    for (final stone in stones) {
      final thisStoneCount = blinkTimes(stone, 75, cache);
      totalStones += thisStoneCount;
    }

    return totalStones;
  }
}
