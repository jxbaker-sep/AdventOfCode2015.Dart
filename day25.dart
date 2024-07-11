
import 'utils/input.dart';
import 'utils/test.dart';

int p(int n) => n * (n+1) ~/ 2;

int v(int r, int c) => p(c) + p(c+r-2) - p(c-1);

int d25(int r, int c) {
  final n = v(r,c)-1;
  var x = 20151125;
  for (final _ in Iterable.generate(n)) {
    x = (x*252533)%33554393;
  }
  return x;
}

Future<void> main() async {
  final input = (await getInput('day25')).split(',').map(int.parse).toList();
  test(d25(input[0], input[1]), 8997277);
}