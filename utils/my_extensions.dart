import 'package:collection/collection.dart';

import 'range.dart';

extension MyExtensions<T> on Iterable<T> {
  int sumBy(int Function(T t) callback) {
    return isEmpty ? 0 : map(callback).reduce((a,b)=>a+b);
  }

  int maxBy(int Function(T t) callback) => map(callback).max;

  Iterable<T2> flatmap<T2>(Iterable<T2> Function(T t) callback) {
    return map(callback).expand((i)=>i);
  }

  Map<T2, T3> toMap<T2, T3>(T2 Function(T t) asKey, T3 Function(T t) asValue) {
    final result = <T2, T3>{};
    for(final item in this) {
      result[asKey(item)] = asValue(item);
    }
    return result;
  }
}

extension MyIntIterableExtensions on Iterable<int> {
  int sum() {
    return isEmpty ? 0 : reduce((a,b)=>a+b);
  }
}

extension MyComparableIterable<T extends Comparable<T>> on Iterable<T> {
  List<T> simpleSort() {
    final l = toList();
    l.sort((a,b) => a.compareTo(b));
    return l;
  }

}

extension MyStringExtensions on String {
  List<String> lines() {
    return split("\n").map((l) => l.trim()).where((t) => t.isNotEmpty).toList();
  }

  List<List<String>> paragraphs() {
    final List<List<String>> result = [];
    var paragraph = <String>[];
    for (final line in split('\n').map((s) => s.trim())) {
      if (line.isEmpty) {
        if (paragraph.isNotEmpty) result.add(paragraph);
        paragraph = [];
      } else {
        paragraph.add(line);
      }
    }
    if (paragraph.isNotEmpty) result.add(paragraph);
    return result;
  }
}

extension MyRegExpMatchExtensions on RegExpMatch {
  String stringGroup(String label) => namedGroup(label)!;
  int intGroup(String label) => int.parse(stringGroup(label));
}

extension MyListExtensions<T> on List<T> {
  Iterable<List<T>> permute() sync* {
    if (isEmpty) {
      yield [];
      return;
    }
    for(final index in range(length)) {
      final remaining = sublist(0, index) + sublist(index + 1);
      for(final other in remaining.permute()) {
        yield [this[index]] + other;
      }
    }
  }
}