

import 'dart:math';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/rectangle.dart';


enum Operation {
  on,
  off,
  toggle
}

class Instruction {
  final Operation operation;
  final Rectangle rectangle;

  Instruction(this.operation, this.rectangle);
}

Operation operationFromString(String s) {
  switch (s) {
    case "toggle": return Operation.toggle;
    case "turn on": return Operation.on;
    case "turn off": return Operation.off;
    default: throw Exception("bad operation: $s");
  }
}

List<Instruction> parseInput(String input) {
  final List<Instruction> result = [];
  final rex = RegExp(r"(?<op>toggle|turn on|turn off) (?<left>\d+),(?<top>\d+) through (?<right>\d+),(?<bottom>\d+)");
  for(final line in input.split("\n")) {
    final m = rex.firstMatch(line);
    if (m == null) throw Exception("Bad line $line");
    result.add(Instruction(operationFromString(m.namedGroup("op")!), Rectangle(int.parse(m.namedGroup("left")!), int.parse(m.namedGroup("top")!), int.parse(m.namedGroup("right")!), int.parse(m.namedGroup("bottom")!))));
  }
  return result;
}

void _do2(List<Instruction> instructions) {

  List<(Rectangle r, int intensity)> grid = [];

  for(final instruction in instructions) {
    final List<(Rectangle r, int intensity)> newGrid = [];
    List<Rectangle> overlaps = [];

    for(final item in grid) {
      final overlap = item.$1.overlap(instruction.rectangle);
      if (overlap == null) {
        newGrid.add(item);
        continue;
      }
      // print("${item.exclude(overlap)}, ${item.exclude(overlap).sum((it) => it.size())}");
      int newIntensity = item.$2;
      if (instruction.operation == Operation.off) newIntensity = max(0, newIntensity-1);
      if (instruction.operation == Operation.on) newIntensity = newIntensity+1;
      if (instruction.operation == Operation.toggle) newIntensity = newIntensity+2;

      newGrid.addAll(item.$1.exclude(overlap).map((r) => (r, item.$2)));
      if (newIntensity > 0) newGrid.add((overlap, newIntensity));
      overlaps.add(overlap);
    }

    if (instruction.operation == Operation.on || instruction.operation == Operation.toggle) {
      List<Rectangle> remainder = [instruction.rectangle];
      for(final overlap in overlaps) {
        remainder = remainder.flatmap((r) => r.exclude(overlap)).toList();
      }
      newGrid.addAll(remainder.map((r) => (r, instruction.operation == Operation.on ? 1 : 2)));
    }
    grid = newGrid;
  }

  print(grid.isNotEmpty ? grid.sumBy((it) => it.$1.size() * it.$2) : 0);
}

void _do1(List<Instruction> instructions) {

  List<Rectangle> grid = [];

  for(final instruction in instructions) {
    final List<Rectangle> newGrid = [];
    List<Rectangle> overlaps = [];

    for(final item in grid) {
      final overlap = item.overlap(instruction.rectangle);
      if (overlap == null) {
        newGrid.add(item);
        continue;
      }
      newGrid.addAll(item.exclude(overlap));
      if (instruction.operation == Operation.on) newGrid.add(overlap);
      overlaps.add(overlap);
    }

    if (instruction.operation == Operation.on || instruction.operation == Operation.toggle) {
      List<Rectangle> remainder = [instruction.rectangle];
      for(final overlap in overlaps) {
        remainder = remainder.flatmap((r) => r.exclude(overlap)).toList();
      }
      newGrid.addAll(remainder);
    }
    grid = newGrid;
  }

  print(grid.isNotEmpty ? grid.map((it) => it.size()).reduce((a,b) => a + b) : 0);
}

Future<void> _part1() async {
  final x = parseInput(await getInput("day06"));
  _do1(x); // 417268 -- too low
}

Future<void> _part2() async {
  final x = parseInput(await getInput("day06"));
  _do2(x); // 417268 -- too low
}

void main() async {
  await _part1();
  await _part2();
}
