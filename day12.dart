import 'dart:convert';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

Iterable<dynamic> nonRedLeaves(dynamic json) sync* {
  if (json is List) {
    for (final item in json) {
      yield* nonRedLeaves(item);
    }
  }
  else if (json is Map) {
    if (json.values.any((s) => s == 'red')) return;
    for(final value in json.values) {
      yield* nonRedLeaves(value);
    }
  }
  else {
    yield json;
  }
}

Iterable<dynamic> leaves(dynamic json) sync* {
  if (json is List) {
    for (final item in json) {
      yield* leaves(item);
    }
  }
  else if (json is Map) {
    for(final value in json.values) {
      yield* leaves(value);
    }
  }
  else {
    yield json;
  }
}

int do1(dynamic json) {
  return leaves(json).whereType<int>().sum();
}

int do2(dynamic json) {
  return nonRedLeaves(json).whereType<int>().sum();
}

Future<void> main() async {
  var data = jsonDecode(await getInput('day12'));
  test(do1(jsonDecode('[1,2,3]')), 6);
  test(do1(jsonDecode('{"a":2,"b":4}')), 6);
  test(do1(jsonDecode('[[[3]]]')), 3);
  test(do1(jsonDecode('{"a":{"b":4},"c":-1}')), 3);
  test(do1(jsonDecode('{"a":[-1,1]}')), 0);
  test(do1(jsonDecode('[-1,{"a":1}]')), 0);
  test(do1(jsonDecode('[]')), 0);
  test(do1(jsonDecode('{}')), 0);
  test(do1(data), 191164);

  test(do2(jsonDecode('[1,2,3]')), 6);
  test(do2(jsonDecode('[1,{"c":"red","b":2},3]')), 4);
  test(do2(jsonDecode('{"d":"red","e":[1,2,3,4],"f":5}')), 0);
  test(do2(jsonDecode('[1,"red",5]')), 6);
  test(do2(data), 0);
}