import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

Future<void> main() async {
  final data = (await getInput('day23')).lines();

  test(do1(data, 0), 307);
  test(do1(data, 1), 160);
}

int do1(List<String> data, int initialA) {
  var pc = 0;
  var r = {'a': initialA, 'b': 0};
  final instructions = data.map((line) => line.replaceAll(',', ' ').split(' ').where((it) => it.isNotEmpty).toList()).toList();
  while (pc < instructions.length) {
    final i = instructions[pc];
    if (i[0] == 'hlf') {
      r[i[1]] = r[i[1]]! ~/ 2;
      pc += 1;
    } else if (i[0] == 'tpl') {
      r[i[1]] = r[i[1]]! * 3;
      pc += 1;
    } else if (i[0] == 'inc') {
      r[i[1]] = r[i[1]]! + 1;
      pc += 1;
    } else if (i[0] == 'jmp') {
      pc += int.parse(i[1]);
    } else if (i[0] == 'jie') {
      if (r[i[1]]! % 2 == 0) {
        pc += int.parse(i[2]);
      } else {
        pc += 1;
      }
    } else if (i[0] == 'jio') {
      if (r[i[1]]! == 1) {
        pc += int.parse(i[2]);
      } else {
        pc += 1;
      }
    } else {
      throw Exception('wut?');
    }
  }
  return r['b']!;
}