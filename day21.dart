import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

class Character {
  final int hp;
  final int damage;
  final int armor;

  Character(this.hp, this.damage, this.armor);
}

class Item {
  final String label;
  final int cost;
  final int damage;
  final int armor;

  Item(this.label, this.cost, this.damage, this.armor);
}

final weapons = [
  Item('Dagger', 8, 4, 0),
  Item("Shortsword", 10,     5,       0),
  Item("Warhammer", 25,     6,       0),
  Item("Longsword", 40,     7,       0),
  Item("Greataxe", 74,     8,       0)
];
final armor = [
  Item("Leather", 13,     0,       1),
  Item("Chainmail", 31,     0,       2),
  Item("Splintmail", 53,     0,       3),
  Item("Bandedmail", 75,     0,       4),
  Item("Platemail1", 102,     0,       5)
];
final rings = [
  Item("Damage +1", 25,     1,       0),
  Item("Damage +2", 50,     2,       0),
  Item("Damage +3", 100,     3,       0),
  Item("Defense +1", 20,     0,       1),
  Item("Defense +2", 40,     0,       2),
  Item("Defense +3", 80,     0,       3),
];

Iterable<List<Item>> loadouts() sync* {  
  for(final weapon in weapons) {
    for (final armor in armor) {
      for (final (ringDex, ring1) in rings.indexed) {
        for (final ring2 in rings.sublist(ringDex+1)) {
          yield [weapon];
          yield [weapon, armor];
          yield [weapon, armor, ring1];
          yield [weapon, armor, ring1, ring2];
          yield [weapon, ring1];
          yield [weapon, ring1, ring2];
        }
      }
    }
  }
}

int turnsToKill(Character killer, Character victim) {
  final dps = [1, killer.damage - victim.armor].max;
  return victim.hp ~/ dps + (victim.hp % dps == 0 ? 0 : 1);
}

bool doesPCWin(Character pc, Character villain) {
  final pcWinsIn = turnsToKill(pc, villain);
  final villainWinsIn = turnsToKill(villain, pc);
  return pcWinsIn <= villainWinsIn;
}

Future<void> main() async {
  final data = await getInput('day21');
  final temp = data.lines().map((line) => line.split(':')[1]).map(int.parse).toList();
  final villain = Character(temp[0], temp[1], temp[2]);

  final costToWin = loadouts()
    .where((lo) {
      final pc = Character(100, lo.sumBy((it)=>it.damage), lo.sumBy((it) => it.armor));
      return doesPCWin(pc, villain);
    })
    .map((lo) => lo.sumBy((it) => it.cost))
    .min;

  final costToLose = loadouts()
    .where((lo) {
      final pc = Character(100, lo.sumBy((it)=>it.damage), lo.sumBy((it) => it.armor));
      return !doesPCWin(pc, villain);
    })
    .map((lo) => lo.sumBy((it) => it.cost))
    .max;

  test(costToWin, 91);
  test(costToLose, 158);
}