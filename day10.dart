
import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/range.dart';
import 'utils/test.dart';


List<String> parse(List<String> data) {
  return data[0].split('');
}


Future<void> main() async {
  final data = parse((await getInput("day10")).lines());
  final sample = parse(['1']);

  test(do1(sample, 5), '312211'.length);
  test(do1(data, 40), 492982);
  test(do1(data, 50), 6989950);

  // test(do2(sample), 982);
  // test(do2(data), 0);

}

Iterable<(int, String)> rle(List<String> input) sync* {
  if (input.isEmpty) return;
  var count = 0;
  var char = input[0];
  for(final c in input) {
    if (c == char) {
      count += 1;
      continue;
    }
    yield (count, char);
    char = c;
    count = 1;
  }
  yield(count, char);
}

int do1(List<String> chars, int iterations) {
  for(final _ in range(iterations)) {
    final current = rle(chars);
    chars = current.flatmap((x) => '${x.$1}'.split('') + [x.$2]).toList();
  }
  return chars.length;
}