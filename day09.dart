
import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';
import 'package:collection/collection.dart';

typedef City = String;
typedef Grid = Map<(City, City), int>;


Grid parse(List<String> data) {
  final result = Grid();

  for(final line in data) {
    final m = RegExp(r"(?<city1>\w+) to (?<city2>\w+) = (?<distance>\d+)").firstMatch(line) ?? (throw Exception("Unmatched $line"));
    result[(m.stringGroup('city1'), m.stringGroup('city2'))] = m.intGroup('distance');
    result[(m.stringGroup('city2'), m.stringGroup('city1'))] = m.intGroup('distance');
  }

  return result;
}

int do1(Grid grid) {
  final cities = grid.keys.flatmap((it) => [it.$1, it.$2]).toSet();
  var open = PriorityQueue<(List<City>, int distance)>((a,b)=> a.$2 - b.$2);
  open.addAll(cities.map((city) => ([city], 0)));
  while (open.isNotEmpty) {
    final current = open.removeFirst();
    final remainingCities = cities.difference(current.$1.toSet());
    if (remainingCities.isEmpty) return current.$2;
    for (final otherCity in remainingCities) {
      open.add((current.$1 + [otherCity], current.$2 + grid[(otherCity, current.$1.last)]!));
    }
  }
  throw Exception("No way!");
}

int findLongest(Grid grid, Set<City> cities, List<City> visited, int distance) {
  if (visited.length == cities.length) return distance;
  final remaining = cities.difference(visited.toSet());
  return remaining.map((other) => findLongest(grid, cities, visited + [other], distance + grid[(visited.last, other)]!)).max;
}

int do2(Grid grid) {
  final cities = grid.keys.flatmap((it) => [it.$1, it.$2]).toSet();
  return cities.map((city) => findLongest(grid, cities, [city], 0)).max;
}


Future<void> main() async {
  final data = parse((await getInput("day09")).lines());
  final sample = parse((await getInput("day09.sample")).lines());

  test(do1(sample), 605);
  test(do1(data), 251);

  test(do2(sample), 982);
  test(do2(data), 0);

}