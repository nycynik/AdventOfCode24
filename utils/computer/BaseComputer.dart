abstract class BaseComputer {
  var Registers = <BigInt>[];
  var ip = 0; //instruction pointer

  BaseComputer() {
    Registers = List.filled(4, BigInt.from(0));
  }

  void turnOn() {
    for (var i = 0; i < Registers.length; i++) {
      Registers[i] = BigInt.from(0);
    }
    ip = 0;
  }

  void turnOff() {}

  void reset() {
    turnOff();
    turnOn();
  }

  String dump() {
    var output = "";
    for (var i = 0; i < Registers.length; i++) {
      output += "Register " + String.fromCharCode('A'.codeUnitAt(0) + i) + ": " + Registers[i].toString() + "\n";
    }
    output += "-----------------------------------\n";
    output += "Instruction Pointer: " + ip.toString() + "\n";

    return output;
  }

  // helpers to return and set registers based on the letters A,B,C,D
  BigInt getA() => Registers[0];
  BigInt getB() => Registers[1];
  BigInt getC() => Registers[2];
  BigInt getD() => Registers[3];
  void setA(BigInt value) => Registers[0] = value;
  void setB(BigInt value) => Registers[1] = value;
  void setC(BigInt value) => Registers[2] = value;
  void setD(BigInt value) => Registers[3] = value;
}
