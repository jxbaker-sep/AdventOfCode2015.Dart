import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/position.dart';
import 'utils/range.dart';
import 'utils/test.dart';

typedef Grid = Set<Position>;

Grid parse(String s) {
  return Set.from(s.lines().indexed
    .flatmap((row) => 
      row.$2.split('').indexed
      .map((col) => (col.$1, row.$1, col.$2)))
    .where((it) => it.$3 == '#')
    .map((it) => Position(it.$1, it.$2)));
}

Future<void> main() async {
  final sample = parse(await getInput('day18.sample'));
  final data = parse(await getInput('day18'));

  test(do1(sample, 4, 6, false), 4);
  test(do1(data, 100, 100, false), 1061);

  test(do1(sample, 5, 6, true), 17);
  test(do1(data, 100, 100, true), 1006);

}

int do1(Grid grid, int generations, int gridSize, bool cornersStuckOn) {
  final corners = {Position(0, 0), Position(0, gridSize-1), Position(gridSize-1, 0), Position(gridSize-1, gridSize-1)};
  if (cornersStuckOn) grid = grid.union(corners);
  onGrid(Position p) => p.x >=0 && p.x < gridSize && p.y >= 0 && p.y < gridSize;
  for (final _ in range(generations)) {
    final neighbors = grid.flatmap((p) => p.neighbors().where(onGrid)).toList();
    // eg, counts[(x, y)] == 5 means that position x,y has 5 neighbors turned on
    final counts = neighbors.groupFoldBy((p) => p, (int? previous, _) => (previous ?? 0) + 1);

    final strictNeighbors = neighbors.toSet().difference(grid);
    grid = grid.where((p) => counts[p] == 2 || counts[p] == 3)
      .followedBy(strictNeighbors.where((p) => counts[p] == 3))
      .followedBy(cornersStuckOn ? corners : [])
      .toSet();
  }
  return grid.length;
}