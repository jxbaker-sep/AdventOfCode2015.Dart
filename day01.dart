import 'utils/check_answer.dart';
import 'utils/input.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<void> _do(int part, int n) async {
  final part1 = await getInput("day01");
  for (final i in Iterable.generate(20000000, (i)=>i)) {
    final key = '$part1$i';
    final needle = generateMd5(key);
    // if (needle.startsWith("0")) print("$needle, ${needle.runes.takeWhile((rune) => String.fromCharCode(rune) == "0").length}, $i");
    if (needle.startsWith("0" * n)) {
      checkAnswer("$i", await getAnswer("day01.part$part"));
      return;
    }
  }
  throw Exception("what?");
}

Future<void> _part1() async {
  print("  Part 1");
  await _do(1, 5);
}


Future<void> _part2() async {
  print("  Part 2");
  await _do(2, 6);
}

void main() async {
  print("Day 01");
  await _part1();
  await _part2();
}
