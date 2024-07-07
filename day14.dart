import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/parse_utils.dart' as my;
import 'utils/range.dart' as my;
import 'utils/test.dart';

class Reindeer {
  final String name;
  final int speed;
  final int energy;
  final int cooldown;

  Reindeer(this.name, this.speed, this.energy, this.cooldown);
}

// Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.

final matcher = (
  my.word.skip(after: string("can fly").trim()).trim() & 
  my.number.skip(after: string("km/s for").trim()) & 
  my.number.skip(after: string("seconds, but then must rest for").trim()) &
  my.number.skip(after: string("seconds.").trim())
  ).map((m) => Reindeer(m.first.toString(), m[1] as int, m[2] as int, m[3] as int ));

List<Reindeer> parse(String input) => input.lines().map((line) => matcher.allMatches(line).first).toList();

int moveDeer(Reindeer deer, int time) {
  final fullIncrement = deer.energy + deer.cooldown;
  final fullIncrements = time ~/ fullIncrement;
  final remainder = min(time % fullIncrement, deer.energy);
  return fullIncrements * (deer.speed * deer.energy) + remainder * deer.speed;
}

int do1(List<Reindeer> deer, int time) {
  var distances = deer.map((d) => moveDeer(d, time)).toList();
  return distances.max;
}

class AnnotatedReindeer {
  final Reindeer deer;
  int energyRemaining;
  int cooldownRemaining = 0;
  int score = 0;
  int distance = 0;

  AnnotatedReindeer(this.deer) : energyRemaining = deer.energy;

  void tick() {
    if (energyRemaining > 0) {
      distance += deer.speed;
      energyRemaining -= 1;
      if (energyRemaining == 0) cooldownRemaining = deer.cooldown;
    } else {
      cooldownRemaining -= 1;
      if (cooldownRemaining == 0) energyRemaining = deer.energy;
    }
  }
}

int do2(List<Reindeer> deer, int time) {
  final scores = deer.map((d) => AnnotatedReindeer(d)).toList();
  for(final _ in my.range(time)) {
    for (final d in scores) {
      d.tick();
    }
    final maxDistance = scores.map((d) => d.distance).max;
    for (final d in scores.where((d) => d.distance == maxDistance)) {
      d.score += 1;
    }
  }
  return scores.map((d) => d.score).max;
}

Future<void> main() async {
  final sample = await getInput('day14.sample');
  final data = await getInput('day14');

  test(do1(parse(sample), 1000), 1120);
  test(do1(parse(data), 2503), 2655);

  test(do2(parse(sample), 1000), 689);
  test(do2(parse(data), 2503), 1059);
}