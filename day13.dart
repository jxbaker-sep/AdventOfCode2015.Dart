import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/test.dart';

class Datum {
  final String p1;
  final String p2;
  final int score;

  Datum(this.p1, this.p2, this.score);
  @override
  String toString() {
    return 'Datum($p1, $p2, $score)';
  }
}

final gainOrLose = (string("gain") | string("lose")).flatten().trim();

final matcher = (my.word.skip(after: string("would").trim()).trim() & gainOrLose & my.number.skip(
  after: string("happiness units by sitting next to").trim()) & my.word)
  .map((m) => Datum(m.first.toString(), m.last.toString(), (m[2] as int) * (m[1] == "gain" ? 1 : -1)));

int score(Map<(String, String), int> scoring, List<String> seating) {
  return Iterable.generate(seating.length, (i) => (i, (i+1) % seating.length))
    .map((pair) => scoring[(seating[pair.$1], seating[pair.$2])]! + scoring[(seating[pair.$2], seating[pair.$1])]!)
    .sum;
}

int do1(List<Datum> data) {
  int max = -99999;
  final scoring = data.toMap((d) => (d.p1, d.p2), (d) => d.score);
  final names = data.flatmap((d) => [d.p1, d.p2]).toSet().toList();
  for (final permutation in names.permute()) {
    final s = score(scoring, permutation);
    if (s > max) max = s;
  }
  return max;
}

Future<void> main() async {
  final sample = (await getInput("day13.sample")).lines().map((line) => matcher.allMatches(line).first).toList();
  final data = (await getInput("day13")).lines().map((line) => matcher.allMatches(line).first).toList();
  // final matches = matcher.allMatches('Alice would gain 54 happiness units by sitting next to Bob.');
  // print(sample);
  final data2 = List<Datum>.from(data);
  final names = data.flatmap((d) => [d.p1, d.p2]).toSet().toList();
  for(final name in names) {
    data2.add(Datum('self', name, 0));
    data2.add(Datum(name, 'self', 0));
  }

  test(do1(sample), 330);
  test(do1(data), 664);
  test(do1(data2), 0);

}