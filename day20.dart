import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

Future<void> main() async {
  final data = int.parse((await getInput('day20')).lines()[0]);
  test(do1(data), 786240);
  test(do2(data), 831600);
}

int do1(int target) {
  final xrange = target ~/ 10;
  final houses = Iterable.generate(xrange, (x) => 0).toList();
  for (var n = 1; n < xrange; n++) {
    for(var house = n; house < xrange; house += n) {
      houses[house] += n * 10;
    }
  }

  for (var n = 1; n < xrange; n++) {
    if (houses[n] >= target) return n;
  }

  throw Exception('wut?');
}

int do2(int target) {
  final xrange = target ~/ 10;
  final houses = Iterable.generate(xrange, (x) => 0).toList();
  for (var n = 1; n < xrange; n++) {
    for(var house = n; house < xrange && house <= n * 50; house += n) {
      houses[house] += n * 11;
    }
  }

  for (var n = 1; n < xrange; n++) {
    if (houses[n] >= target) return n;
  }

  throw Exception('wut?');
}
