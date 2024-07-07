import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/test.dart';

typedef Sue = Map<String, int>;

// Sue 4: goldfish: 5, children: 8, perfumes: 3
final matcher = (
  my.number.skip(before: string("Sue").trim(), after: string(":")) &
  my.word.skip(after: string(':')) &
  my.number.skip(after: string(',')) & 
  my.word.skip(after: string(':')) &
  my.number.skip(after: string(',')) &
  my.word.skip(after: string(':')) &
  my.number 
  ).map((m) {
    final sue = {
      m[1] as String: m[2] as int,
      m[3] as String: m[4] as int,
      m[5] as String: m[6] as int,
    };
    return sue;
  });

List<Sue> parse(String input) => input.lines().map((line) => matcher.allMatches(line).first).toList();

Future<void> main() async {
  final data = parse(await getInput('day16'));

  test(do1(data), 213);
  test(do2(data), 323);
}

int do1(List<Sue> sueList) {
  final detected = {
    'children': 3,
    'cats': 7,
    'samoyeds': 2,
    'pomeranians': 3,
    'akitas': 0,
    'vizslas': 0,
    'goldfish': 5,
    'trees': 3,
    'cars': 2,
    'perfumes': 1,
  };

  for (final (index, sue) in sueList.indexed) {
    if (sue.entries.where((entry) => detected[entry.key] == entry.value).length == 3) {
      return index + 1;
    }
  }
  throw Exception('wut?');
}

int do2(List<Sue> sueList) {
  final Map<String, bool Function(int sues)> detected = {
    'children': (sues) => sues == 3,
    'cats': (sues) => sues > 7,
    'samoyeds': (sues) => sues == 2,
    'pomeranians': (sues) => sues < 3,
    'akitas': (sues) => sues == 0,
    'vizslas': (sues) => sues == 0,
    'goldfish': (sues) => sues < 5,
    'trees': (sues) => sues > 3,
    'cars': (sues) => sues == 2,
    'perfumes': (sues) => sues == 1,
  };

  for (final (index, sue) in sueList.indexed) {
    if (sue.entries.where((entry) => detected[entry.key]!(entry.value)).length == 3) {
      return index + 1;
    }
  }
  throw Exception('wut?');
}