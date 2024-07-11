
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/test.dart';

final matcher = (
  my.word.skip(after: string('=>')) &
  my.word
  ).map((m) => (m[0] as String, m[1] as String));

typedef Molecule = String;
typedef Replacements = Map<String, List<Molecule>>;
typedef Day19Input = (Replacements, Molecule);

Day19Input parse(String s) {
  final p = s.paragraphs().toList();
  if (p.length != 2) throw Exception('p != 2');
  final m = p[0].map((line) => matcher.allMatches(line).first)
    .groupFoldBy((it) => it.$1, (List<Molecule>? p, it) {
      final v = p ?? []; 
      v.add((it.$2)); 
      return v;
    });
  return (m, (p[1].single));
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
  return expandMolecule(input.$1, input.$2).toSet().length;
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

Iterable<Molecule> expandMolecule(Replacements input, Molecule molecule) sync* {
  for(final entry in input.entries) {
    final matches = entry.key.allMatches(molecule);
    for(final repl in entry.value) {
      for(final m in matches) {
        final result = molecule.substring(0, m.start) + repl + molecule.substring(m.end);
        yield result;
      }
    }
  }
}

Iterable<Molecule> collapseMolecule(Replacements input, Molecule molecule) sync* {
  for(final entry in input.entries) {
    for(final repl in entry.value) {
      final matches = repl.allMatches(molecule);
      for(final m in matches) {
        final result = molecule.substring(0, m.start) + entry.key + molecule.substring(m.end);
        if (entry.key == 'e') {
          if (result == 'e') yield 'e';
          continue;
        }
        yield result;
      }
    }
  }
}