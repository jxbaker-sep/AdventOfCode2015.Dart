
import 'utils/input.dart';
import 'utils/my_extensions.dart';

typedef Circuit = Map<String, IConnection>;

Map<String, int> known = {};

extension on Circuit {
  // int value(String label) => this[label]!.value(this) & 0xFFFF;

  int value(String label) {
    final k = known[label];
    if (k != null) return k;
    final v = this[label]!.value(this) & 0xFFFF;
    known[label] = v;
    return v;
  }

}

abstract class IConnection {
  late String label;
  int value(Circuit circuit);
}

abstract class Dereference {
  int value(Circuit circuit);

  static Dereference parse(String s) {
    final literal = int.tryParse(s);
    if (literal != null) return LiteralReference(literal);
    return RegisterReference(s);
  }
}

class RegisterReference implements Dereference {
  final String register;
  RegisterReference(this.register);
  
  @override
  int value(Circuit circuit) => circuit.value(register);
}

class LiteralReference implements Dereference {
  final int literal;
  LiteralReference(this.literal);
  
  @override
  int value(Circuit circuit) => literal;
}

class DirectConnection implements IConnection {
  @override
  int value(Circuit circuit) => _lhs.value(circuit);
  
  @override
  String label;
  final Dereference _lhs;
  
  DirectConnection(this.label, this._lhs);
}

class AndConnection implements IConnection {
  @override
  int value(Circuit circuit) =>
    _lhs.value(circuit) & _rhs.value(circuit);
  
  @override
  String label;
  final Dereference _lhs;
  final Dereference _rhs;
  
  AndConnection(this.label, this._lhs, this._rhs);
}

class OrConnection implements IConnection {
  @override
  int value(Circuit circuit) =>
    _lhs.value(circuit) | _rhs.value(circuit);
  
  @override
  String label;
  final Dereference _lhs;
  final Dereference _rhs;
  
  OrConnection(this.label, this._lhs, this._rhs);
}

class LShiftConnection implements IConnection {
  @override
  int value(Circuit circuit) => _lhs.value(circuit) << _rhs;
  
  @override
  String label;
  final Dereference _lhs;
  final int _rhs;
  
  LShiftConnection(this.label, this._lhs, this._rhs);
}

class RShiftConnection implements IConnection {
  @override
  int value(Circuit circuit) =>
    _lhs.value(circuit) >> _rhs;
  
  @override
  String label;
  final Dereference _lhs;
  final int _rhs;
  
  RShiftConnection(this.label, this._lhs, this._rhs);
}

class NotConnection implements IConnection {
  @override
  int value(Circuit circuit) => ~_lhs.value(circuit);
  
  @override
  String label;
  final Dereference _lhs;
  
  NotConnection(this.label, this._lhs);
}

IConnection parseLine(String l) {
  var m = RegExp(r"^(?<lhs>\w+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return DirectConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')));
  }

  m = RegExp(r"(?<lhs>\w+) AND (?<rhs>\w+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return AndConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')), Dereference.parse(m.stringGroup('rhs')));
  }

  m = RegExp(r"(?<lhs>\w+) OR (?<rhs>\w+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return OrConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')), Dereference.parse(m.stringGroup('rhs')));
  }

  m = RegExp(r"(?<lhs>\w+) LSHIFT (?<rhs>\d+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return LShiftConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')), m.intGroup('rhs'));
  }

  m = RegExp(r"(?<lhs>\w+) RSHIFT (?<rhs>\d+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return RShiftConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')), m.intGroup('rhs'));
  }

  m = RegExp(r"NOT (?<lhs>\w+) -> (?<label>\w+)").firstMatch(l);
  if (m != null) {
    return NotConnection(m.stringGroup('label'), Dereference.parse(m.stringGroup('lhs')));
  }

  throw Exception("Not pattern matched: $l");
}

Circuit parseLines(String input) {
  final result = Circuit();
  for (final l in input.lines()) {
    final c = parseLine(l);
    result[c.label] = c;
  }  

  return result;
}

Future<void> part1(Circuit circuit) async {
  print(circuit.value('a')); // 5 is not correct
}

void main() async {
//   final sample = parseLines("""
// 123 -> x
// 456 -> y
// x AND y -> d
// x OR y -> e
// x LSHIFT 2 -> f
// y RSHIFT 2 -> g
// NOT x -> h
// NOT y -> i
// """);
  final sample = parseLines(await getInput("day07"));
  // for(final z in sample.keys.simpleSort()) {
  //   print("$z: ${sample.value(z)}");
  // }
  final a1 = sample.value('a');
  print(a1);
  known.clear();
  sample['b'] = DirectConnection('b', LiteralReference(a1));
  print(sample.value('a'));
  // print(parseLines(await getInput("day07")).value('a'));
  // await part1(sample);
  // await part2();
}
