import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

List<int> parse(String input) => input.split('\n').map(int.parse).toList();

Future<void> main() async {
  final sample = parse(await getInput('day24.sample'));
  final data = parse(await getInput('day24'));

  // test(do1(sample), 99);
  test(do1(data), 0);
}

int do1(List<int> sample) {
  final needle = sample.sum ~/ 3;
  if (sample.sum % 3 != 0) throw Exception();
  final triplets = findTriplets(sample, needle).toList();
  print(triplets.length);

  final smallest = triplets.flatmap((t) => [t.$1.length, t.$2.length, t.$3.length]).min;
  final selected = triplets.where((t) => t.$1.length == smallest || t.$2.length == smallest || t.$3.length == smallest).toList();
  return selected.map((t) => quantumEntanglement(t)).min;
}

typedef Triplet = (List<int>, List<int>, List<int>);

int quantumEntanglement(Triplet t) {
  return [t.$1, t.$2, t.$3].map((it) => it.reduce((a,b) => a*b)).min;
}

Iterable<Triplet> findTriplets(List<int> initial, int needle) sync* {
  final subsets1 = findSubset(initial, needle);
  for (final (t1dex, t1) in subsets1.indexed) {
    print(t1);
    for (final t2 in subsets1.skip(t1dex + 1)) {
      final remainder2 = initial.toSet().difference(t1.toSet()).difference(t2.toSet());
      if (remainder2.sum == needle) yield (t1, t2, remainder2.toList());
    }
  }
}

final Map<(String, int), List<List<int>>> _cache = {};
List<List<int>> findSubset(List<int> initial, int needle) {
  if (needle == 0) {
    return [[]];
  }
  if (initial.isEmpty) return [];
  final key = (initial.join(","), needle);
  if (_cache.containsKey(key)) return _cache[key]!;
  final first = initial.first;
  // Note: this depends on the property of the list being in ascending order
  if (first > needle) return [];
  final List<List<int>> result = [];
  result.addAll(findSubset(initial.sublist(1), needle));
  result.addAll(findSubset(initial.sublist(1), needle - first).map((it) => [first] + it));
  _cache[key] = result;
  return result;
}