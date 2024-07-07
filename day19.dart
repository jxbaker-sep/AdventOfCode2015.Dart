
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/test.dart';
import 'utils/range.dart' as my;

final matcher = (
  my.word.skip(after: string('=>')) &
  my.word
  ).map((m) => (m[0] as String, m[1] as String));

typedef Molecule = List<String>;
typedef Replacements = Map<String, List<Molecule>>;
typedef Day19Input = (Replacements, Molecule);

Day19Input parse(String s) {
  final p = s.paragraphs().toList();
  if (p.length != 2) throw Exception('p != 2');
  final m = p[0].map((line) => matcher.allMatches(line).first)
    .groupFoldBy((it) => it.$1, (List<Molecule>? p, it) {
      final v = p ?? []; 
      v.add(splitIntoAtoms(it.$2)); 
      return v;
    });
  return (m, splitIntoAtoms(p[1].single));
}

Future<void> main() async {
  final sample = parse(await getInput('day19.sample'));
  final data = parse(await getInput('day19'));
  test(do1(sample), 4);
  test(do1(data), 509);
  test(do2(sample), 3);
  test(do2(data), 195);

}

int do1(Day19Input input) {
  return expandMolecule(input.$1, input.$2).map((l) => l.join()).toSet().length;
}

int do2(Day19Input input) {
  final (replacements, goal) = input;
  final open = PriorityQueue<(Molecule, int)>((m1, m2) => m1.$1.length - m2.$1.length);
  open.add((goal, 0));
  while (open.isNotEmpty) {
    final current = open.removeFirst();
    final collapsed = collapseMolecule(replacements, current.$1);
    for(final item in collapsed) {
      if (item[0] == 'e') return current.$2 + 1;
      open.add((item, current.$2 + 1));
    }
  }
  throw Exception('wut?');
}

Molecule splitIntoAtoms(String input) => RegExp(r'[A-Z][a-z]*').allMatches(input).map((m) => m[0]!).toList();

List<Molecule> expandMolecule(Replacements input, Molecule molecule) {
  final List<Molecule> result = [];
  for(final index in my.range(molecule.length)) {
    final element = molecule[index];
    if (input[element] != null) {
      for(final repl in input[element]!) {
        result.add(molecule.sublist(0, index) + repl + molecule.sublist(index + 1));
      }
    }
  }
  return result;
}

Iterable<Molecule> collapseMolecule(Replacements input, Molecule molecule) sync* {
  final mString = molecule.join();
  for(final entry in input.entries) {
    for(final repl_ in entry.value) {
      final repl = repl_.join();
      final matches = repl.allMatches(mString);
      for(final m in matches) {
        final result = mString.substring(0, m.start) + entry.key + mString.substring(m.end);
        if (entry.key == 'e') {
          if (result == 'e') yield ['e'];
          continue;
        }
        yield splitIntoAtoms(result);
      }
    }
  }
}