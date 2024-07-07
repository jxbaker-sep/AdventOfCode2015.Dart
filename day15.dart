import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/test.dart';

class Ingredient {
  final String label;
  final int capacity;
  final int durability;
  final int flavor;
  final int texture;
  final int calories;

  Ingredient(this.label, this.capacity, this.durability, this.flavor,
      this.texture, this.calories);
}

// Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
final matcher = (my.word.skip(after: string(":").trim()).trim() &
        my.number.skip(
            before: string("capacity").trim(), after: string(",").trim()) &
        my.number.skip(
            before: string("durability").trim(), after: string(",").trim()) &
        my.number
            .skip(before: string("flavor").trim(), after: string(",").trim()) &
        my.number
            .skip(before: string("texture").trim(), after: string(",").trim()) &
        my.number.skip(before: string("calories").trim()))
    .map((m) => Ingredient(m[0] as String, m[1] as int, m[2] as int,
        m[3] as int, m[4] as int, m[5] as int));

List<Ingredient> parse(String input) =>
    input.lines().map((line) => matcher.allMatches(line).first).toList();

Iterable<List<int>> equalingGroups(int sum, int nGroups) sync* {
  if (nGroups == 0) {
    yield [];
    return;
  }
  if (nGroups == 1) {
    yield [sum];
    return;
  }
  for (var i = 1; i < sum - nGroups + 1; i++) {
    for (final subgroup in equalingGroups(sum - i, nGroups - 1)) {
      yield [i] + subgroup;
    }
  }
}

int sum1group(List<Ingredient> ingredients, List<int> counts) {
  var capacity = 0;
  var durability = 0;
  var flavor = 0;
  var texture = 0;
  for (final (index, count) in counts.indexed) {
    capacity += ingredients[index].capacity * count;
    durability += ingredients[index].durability * count;
    flavor += ingredients[index].flavor * count;
    texture += ingredients[index].texture * count;
  }
  return [capacity, 0].max *
      [durability, 0].max *
      [flavor, 0].max *
      [texture, 0].max;
}

int sumCalories(List<Ingredient> ingredients, List<int> counts) {
  var calories = 0;
  for (final (index, count) in counts.indexed) {
    calories += ingredients[index].calories * count;
  }
  return calories;
}

int do1(List<Ingredient> ingredients) {
  return equalingGroups(100, ingredients.length)
      .maxBy((it) => sum1group(ingredients, it));
}

int do2(List<Ingredient> ingredients) {
  return equalingGroups(100, ingredients.length)
      .where((it) => sumCalories(ingredients, it) == 500)
      .maxBy((it) => sum1group(ingredients, it));
}

Future<void> main() async {
  final sample = parse(await getInput('day15.sample'));
  final data = parse(await getInput('day15'));

  test(do1(sample), 62842880);
  test(do1(data), 18965440);

  test(do2(sample), 57600000);
  test(do2(data), 15862900);
}
