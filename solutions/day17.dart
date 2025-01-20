import 'package:chalkdart/chalk.dart';
import 'dart:io';

import '../utils/computer/BaseComputer.dart';
import '../utils/index.dart';

class ThreeBitComputer extends BaseComputer {
  var instructions = <int>[];
  final opcodes = ['adv', 'bxl', 'bst', 'jnz', 'bxc', 'out', 'bdv', 'cvd'];
  String output = '';

  void load(String program) {
    instructions = program.trim().split(',').map(int.parse).toList();
  }

  String list({int start = 0, int lines = 0}) {
    var idx = start;
    var endIdx = lines == 0 ? instructions.length : start + lines;
    String programList = '';

    while (idx < endIdx && idx < instructions.length) {
      var opcode = instructions[idx];
      var param = instructions[idx + 1];
      var combo = getCombo(param);
      var op = opcodes[opcode];

      if (idx == ip)
        programList += chalk.red('>');
      else
        programList += ' ';
      programList += chalk.yellow(
          '${(ip + idx).toString().padLeft(4, '0')}: 0x${opcode.toRadixString(16).padLeft(4, '0')} 0x${param.toRadixString(16).padLeft(4, '0')}  $op  $param $combo');
      if (output.length > 0 && idx == 0) programList += chalk.green('  ; $output');
      programList += '\n';
      idx += 2;
    }
    return programList;
  }

  void dbg() {
    while (ip < instructions.length) {
      print(dump());
      run(maxCycles: 1, debug: true);
      var cmd = stdin.readByteSync();
    }
  }

  void run({int maxCycles = 0, bool debug = false}) {
    output = '';
    var rounds = 0;
    var cycles = maxCycles != 0 ? maxCycles : 1000000;

    while (ip < instructions.length) {
      var opcode = instructions[ip];
      var param = instructions[ip + 1];
      var op = opcodes[opcode];

      rounds++;
      if (rounds > cycles) return;
      if (rounds > 10000) throw Exception('Too many rounds: $rounds');

      if (debug) print(dump());

      switch (op) {
        case 'adv':
          adv();
          break;
        case 'bxl':
          bxl();
          break;
        case 'bst':
          bst();
          break;
        case 'jnz':
          if (jnz()) continue; // this is to prevent changing of ip, if jumping.
          break;
        case 'bxc':
          bxc();
          break;
        case 'out':
          out();
          break;
        case 'bdv':
          bdv();
          break;
        case 'cvd':
          cdv();
          break;
        default:
          print('Unknown opcode: $op');
          break;
      }
      ip++;
    }
  }

  BigInt getCombo(int val) {
    if (val < 4) return BigInt.from(val);
    if (val == 4) return getA();
    if (val == 5) return getB();
    if (val == 6) return getC();
    if (val == 7) throw Exception('Invalid combo value: $val');
    throw Exception('No combo value: $val');
  }

  void bxl() {
    var b = getB();
    var param = instructions[++ip];

    setB(b ^ BigInt.from(param));
  }

  // modulo 8 the param and store in B
  void bst() {
    var param = instructions[++ip];
    setB(getCombo(param) % BigInt.from(8));
  }

  // jump if A non zero
  bool jnz() {
    var a = getA();
    var param = instructions[++ip];

    if (a != BigInt.from(0)) {
      // jump!
      ip = param;
      return true;
    }
    return false;
  }

  // bitwise XOR of register B and register C
  void bxc() {
    var b = getB();
    var c = getC();
    setC(b ^ c);
    // for legacy reasons..
    ip++; // var param = instructions[ip++];
  }

  void out() {
    var param = instructions[++ip];
    var outputValue = getCombo(param) % BigInt.from(8);
    output += '$outputValue,';
    print('Output: $outputValue');
  }

  void adv() {
    var a = getA();
    var param = instructions[++ip];

    setA(a ~/ BigInt.from(2).pow(getCombo(param).toInt()));
  }

  void bdv() {
    var a = getA();
    var param = instructions[++ip];

    setB(a ~/ BigInt.from(2).pow(getCombo(param).toInt()));
  }

  void cdv() {
    var a = getA();
    var param = instructions[++ip];

    setC(a ~/ BigInt.from(2).pow(getCombo(param).toInt()));
  }

  @override
  String dump() {
    var output = "  IP: ${ip.toString().padLeft(4, '0')}";

    for (var i = 0; i < Registers.length; i++) {
      output += chalk.green(' REG${String.fromCharCode('A'.codeUnitAt(0) + i)}: ');
      output += chalk.blue('${Registers[i].toString().padRight(20, ' ')}');
    }
    output += "\n";

    output += list(start: ip, lines: 10);
    return output;
  }
}

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  ThreeBitComputer parseInput() {
    var comp = ThreeBitComputer();
    final lines = input.getPerLine();

    for (final line in lines) {
      if (line.isEmpty) continue;
      var data = line.split(': ');
      if (data[0] == 'Register A') comp.setA(BigInt.from(int.parse(data[1])));
      if (data[0] == 'Register B') comp.setB(BigInt.from(int.parse(data[1])));
      if (data[0] == 'Register C') comp.setC(BigInt.from(int.parse(data[1])));
      if (data[0] == 'Program') comp.load(data[1]);
    }

    return comp;
  }

  @override
  int solvePart1() {
    var computer = parseInput();

    // tests
    var c1 = ThreeBitComputer();
    c1.setC(BigInt.from(9));
    c1.load('2,6');
    c1.run();
    if (c1.getB() != BigInt.from(1)) throw Exception('A Test failed');

    c1.reset();
    c1.setA(BigInt.from(10));
    c1.load('5,0,5,1,5,4');
    c1.run();
    if (c1.output != '0,1,2,') throw Exception('B Test failed');

    c1.reset();
    c1.setB(BigInt.from(29));
    c1.load('1,7');
    c1.run();
    print(c1.dump());
    if (c1.Registers[1] != BigInt.from(26)) throw Exception('C Test failed');

    c1.reset();
    c1.setB(BigInt.from(2024));
    c1.setC(BigInt.from(43690));
    c1.load('4,0');
    c1.run();
    print(c1.dump());
    if (c1.Registers[2] != BigInt.from(44354)) throw Exception('D Test failed');

    c1.reset();
    c1.setA(BigInt.from(2024));
    c1.load('0,1,5,4,3,0');
    c1.run(debug: true);
    print(c1.output);
    print(c1.list());
    if (c1.output != '4,2,5,6,7,7,7,7,3,1,0,') throw Exception('E Test failed');
    c1.reset();

    print('do!!');
    print(computer.list());
    print(computer.dump());
    computer.run();
    print('computer output : ${computer.dump()}');
    print(computer.output);

    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
