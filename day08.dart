import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

String toInMemory(String s) {
  final rx = RegExp(r'(\\\\|\\"|\\x..|.)');
  final matches =
      rx.allMatches(s.substring(1, s.length - 1)).map((it) => it.group(0)!);
  String result = "";
  for (final m in matches) {
    if (m == r'\"' || m == r'\\') {
      result += m[1];
    } else if (m.startsWith(r'\')) {
      result += '_';
    } else if (m.length == 1) {
      result += m;
    } else {
      throw Exception("what? $m");
    }
  }
  return result;
}

String reincode(String s) {
  var result = "";
  for (final c in s.split('')) {
    switch (c) {
      case r'\': result += r'\\';
      case '"': result += r'\"';
      default: result += c;
    }
  }

  return '"$result"';
}

int do1(List<String> input) {
  final code = input.sumBy((it) => it.length);
  final mem = input.map(toInMemory).sumBy((it) => it.length);
  return code - mem;
}

int do2(List<String> input) {
  final code = input.sumBy((it) => it.length);
  final code2 = input.map(reincode).sumBy((it) => it.length);
  return code2 - code;
}

Future<void> main() async {
  final sample = (await getInput("day08.sample")).lines();
  final data = (await getInput("day08")).lines();
  // print(sample);
  test(do1(sample), 12);
  test(do1([r'"\\xlv"']), 3);
  test(do1(data), 1350); 

  test(do2(sample), 19);
  test(do2(data), 2085);
}
