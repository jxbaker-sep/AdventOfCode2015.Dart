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
  for (final t1 in subsets1) {
    print(t1);
    final tdiff = initial.toSet().difference(t1.toSet()).toList();
    tdiff.sort();
    final subsets2 = findSubset(tdiff, needle);
    for (final t2 in subsets2) {
      final tdiff2 = tdiff.toSet().difference(t2.toSet()).toList();
      tdiff2.sort();
      final subsets3 = findSubset(tdiff2, needle);
      for (final t3 in subsets3) {
        // print('$t1,$t2,$t3');
        yield (t1, t2, t3);
      }
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