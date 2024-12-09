import '../utils/index.dart';

class DiskData {
  int val;
  int len;
  bool wasMoved;

  DiskData({required this.val, required this.len, this.wasMoved = false});

  @override
  String toString() {
    final val = (this.val == -1) ? '.' : this.val.toString();
    return '($len ${val}s)$wasMoved';
  }
}

class Disk {
  List<DiskData> disk;
  Disk({required this.disk});

  void add(DiskData block) {
    disk.add(block);
  }

  @override
  String toString() {
    var diskString = '';
    for (final block in disk) {
      var blockVal = (block.val == -1) ? '.' : block.val.toString();
      if (blockVal.length > 1) blockVal = 'X';
      diskString += blockVal * block.len;
    }
    return diskString;
  }
}

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Map<int, DiskData> parseInput() {
    int currentIdx = 0;
    var diskMap = <int, DiskData>{};
    var diskData = input.asString
        .trim()
        .split('')
        .map(
          (e) => int.parse(e),
        )
        .toList();

    bool isFile = true;
    for (var x = 0; x < diskData.length; x++) {
      var value = -1;
      if (isFile) {
        value = currentIdx;
        currentIdx++;
      }
      diskMap[x] = DiskData(val: value, len: diskData[x]);

      isFile = !isFile;
    }
    //print(diskMap);
    return diskMap;
  }

  // frag means to frament files, if frag is false, it only
  // moves whole files.
  Disk compactDisk(Map<int, DiskData> diskMap, {bool frag = true}) {
    Disk compactedDisk = Disk(disk: []);
    var diskMapKeys = diskMap.keys.toList();
    if (diskMapKeys.length == 1) {
      // if only one, just return that.
      compactedDisk.add(DiskData(val: diskMap[diskMapKeys[0]]!.val, len: 1));
    }

    // HERE WE GO
    var fwdIdx = 0;
    var backIndex = diskMapKeys.last;

    var backData = diskMap[backIndex];

    while (fwdIdx <= backIndex) {
      final fwdData = diskMap[fwdIdx];
      if (fwdData == null) continue;
      if (backData!.val == -1) {
        backData = diskMap[--backIndex];
        continue;
      }

      // print(
      //     'fwd: $fwdIdx back: $backIndex block val: $fwdData  next val: $backData');
      if (fwdData.val != -1) {
        // not free space, so place it as is.
        if (fwdData.wasMoved) {
          compactedDisk.add(DiskData(val: -1, len: fwdData.len));
        } else {
          compactedDisk.add(fwdData);
        }
        //print('  pushed as is $fwdData');
      } else {
        DiskData? insertedBlock;
        // free space, so try to move from end
        var freeSpaceLeft = fwdData.len;
        if (frag) {
          while (freeSpaceLeft > 0 && backData != null && fwdIdx <= backIndex) {
            // one character at a time, move into the free
            // space. If we run out of things to move, we
            // move the index back one and try again.
            // print(nextData);
            if (backData.val == -1) {
              // end has empty space, so skip it
              backIndex--;
              backData = diskMap[backIndex];
              // print(
              //     '          back: $backIndex block val: $fwdData  next val: $backData');
            } else {
              // end has free data, move up
              if (insertedBlock == null) {
                insertedBlock = DiskData(val: backData.val, len: 1);
              } else {
                insertedBlock.len++;
              }
              //print(' :: $insertedBlock');
              backData.len--;
              freeSpaceLeft--;
              if (backData.len == 0) {
                // end has no more data, so move back one
                compactedDisk.add(insertedBlock);
                insertedBlock = null;
                backIndex--;
                backData = diskMap[backIndex];
                //print('  compacted empty space with ${insertedBlock?.val}');
              }
            }
          }
        } else {
          // no frag
          // search starting at the back for an item that fits and was
          // not yet moved. If we find it, and move it.
          //print(fwdData);
          {
            var found = false;
            for (var x = backIndex; x >= fwdIdx; x--) {
              // print('$x: ${diskMap[x]!}');
              if (diskMap[x]!.val != -1 &&
                  !diskMap[x]!.wasMoved &&
                  diskMap[x]!.len <= freeSpaceLeft) {
                // found a block that can be moved
                diskMap[x]!.wasMoved = true;
                // print(diskMap[x]!);
                compactedDisk.add(diskMap[x]!);
                found = true;
                // print('  compacted ${diskMap[x]}');

                // deal with extra space
                if (diskMap[x]!.len < freeSpaceLeft) {
                  freeSpaceLeft -= diskMap[x]!.len;
                  // compactedDisk.add(DiskData(val: -1, len: freeSpaceLeft));
                  // hacky!
                  fwdData.val = -1;
                  fwdData.len = freeSpaceLeft;
                  fwdIdx--; // <- hacky! repeats this idx.
                  // print('added space back');
                }
                break;
              }
            }
            if (!found) {
              // no block found, so just add the free space
              compactedDisk.add(fwdData);
            }
          }
        }

        if (insertedBlock != null) {
          compactedDisk.add(insertedBlock);
          //print('  compacted empty space with ${insertedBlock.val}');
        }
      }
      fwdIdx++;
    }
    // print(' f compacted disk: $compactedDisk');

    return compactedDisk;
  }

  int part1Calculate(Disk disk) {
    int total = 0;
    int lastTotal = 0;
    int idx = 0;
    for (final block in disk.disk) {
      if (block.val == -1) {
        idx += block.len;
      } else {
        for (var x = 0; x < block.len; x++) {
          lastTotal = total;
          total += block.val * idx;
          idx++;
          if (total < lastTotal) print("no $total");
        }
      }
    }

    return total;
  }

  @override
  int solvePart1() {
    var diskMap = parseInput();
    var compacted = compactDisk(diskMap);
    // print(' compacted data: $compacted');
    return part1Calculate(compacted);
  }

  @override
  int solvePart2() {
    var diskMap = parseInput();
    var compacted = compactDisk(diskMap, frag: false);
    // print(' compacted data: $compacted');
    return part1Calculate(compacted);
  }
}

// 2333133121414131402
// 2.3.1.3.2.4.4.3.4.2
