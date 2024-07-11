import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

List<int> parse(String input) => input.split('\n').map(int.parse).toList();

Future<void> main() async {
  final sample = parse(await getInput('day24.sample'));
  final data = parse(await getInput('day24'));

  // test(do1(sample), 99);
  // test(do1(data), 10439961859);

  test(do2(sample), 44);
  test(do2(data), 72050269);
}

int do1(List<int> sample) {
  _cache.clear();
  final needle = sample.sum ~/ 3;
  if (sample.sum % 3 != 0) throw Exception();
  final triplets = findTriplets(sample, needle);
  return quantumEntanglement(triplets);
}

int do2(List<int> sample) {
  _cache.clear();
  final needle = sample.sum ~/ 4;
  if (sample.sum % 4 != 0) throw Exception();
  final triplets = findQuadruplets(sample, needle);
  return quantumEntanglement(triplets);
}

typedef Triplet = (List<int>, List<int>, List<int>);

int quantumEntanglement(List<int> l) => l.reduce((a,b) => a*b);

List<int> findTriplets(List<int> initial, int needle) {
  final temp2 = findSubset(initial, needle);
  final temp = temp2.groupFoldBy((a) => a.length, (List<List<int>>? previous, current) {
    if (previous == null) return [current];
    previous.add(current);
    return previous;
  });
  for (final value in temp.values) {
    value.sort((a,b) => quantumEntanglement(a) - quantumEntanglement(b));
  }
  var subsets1 = temp.keys.sorted((a,b) => a - b).flatmap((key) => temp[key]!);
  int? smallestKnown;
  for (final (t1dex, t1) in subsets1.indexed) {
    print('$t1: $smallestKnown');
    for (final t2 in subsets1.skip(t1dex + 1)) {
      final remainder2 = initial.toSet().difference(t1.toSet()).difference(t2.toSet());
      if (remainder2.sum == needle) {
        // yield (t1, t2, remainder2.toList());
        return t1;
        // smallestKnown = t1.length;
        // return; // items are in order of smallest set to largest set, smallest QE to largest QE
      }
    }
  }
  throw Exception();
}


List<int> findQuadruplets(List<int> initial, int needle) {
  final subsets1 = findSubset(initial, needle);
    subsets1.sort((a,b) => (a.length == b.length) ? quantumEntanglement(a) - quantumEntanglement(b) : a.length - b.length);
  int? smallestKnown;
  for (final (t1dex, t1) in subsets1.indexed) {
    print('$t1: $smallestKnown');
    for (final (t2dex, t2) in subsets1.skip(t1dex + 1).indexed) {
      if (t1.toSet().intersection(t2.toSet()).isNotEmpty) continue;
      for (final (t3dex, t3) in subsets1.skip(t2dex + 1).indexed) {
        final remainder2 = initial.toSet().difference(t1.toSet()).difference(t2.toSet()).difference(t3.toSet());
        if (remainder2.sum == needle) {
          // because we sorted by length and then by QE, the first hit is correct
          return t1;
        }
      }
    }
  }
  throw Exception();
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