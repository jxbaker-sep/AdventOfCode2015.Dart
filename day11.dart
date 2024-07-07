
import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

bool isPasswordLegal(String pw) {
  final runes = pw.runes;
  var last = -1;
  var last2 = -1;
  var dupCount = 0;
  var lastMatchedDuped = false;
  var runDetected = false;
  for (final rune in runes) {
    if (!lastMatchedDuped) {
      if (rune == last) {
        dupCount += 1;
        lastMatchedDuped = true;
      }
    }
    else {
      lastMatchedDuped = false;
    }
    if (rune == last + 1 && last == last2 + 1) {
      runDetected = true;
    }
    last2 = last;
    last = rune;
  }

  return runDetected && dupCount >= 2;
}

final a = 'a'.runes.first;
final i = 'i'.runes.first;
final l = 'l'.runes.first;
final o = 'o'.runes.first;
final z = 'z'.runes.first;

String increment(String pw) {
  var index = pw.length-1;
  var runes = pw.runes.toList();
  while (index >= 0) {
    if (runes[index] == z) {
      runes[index] = a;
      index -= 1;
      continue;
    }
    runes[index] += 1;
    if ([i, o, l].contains(runes[index])) continue;
    return runes.map((rune) => String.fromCharCode(rune)).join();
  }
  throw Exception('what?');
}

String nextPassword(String pw) {
  while (true) {
    pw = increment(pw);
    if (isPasswordLegal(pw)) return pw;
  }
}

Future<void> main() async {
  test(isPasswordLegal('abbceffg'), false);
  test(isPasswordLegal('abbcegjk'), false);
  test(nextPassword('abcdefgh'), 'abcdffaa');
  test(nextPassword('ghjaaaaa'), 'ghjaabcc');
  test(nextPassword((await getInput('day11')).lines()[0]), 'cqjxxyzz');
  test(nextPassword('cqjxxyzz'), '');
}