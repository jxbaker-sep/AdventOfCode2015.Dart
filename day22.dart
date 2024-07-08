import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';

class Character {
  final int hp;
  final int damage;
  final int armor;

  Character(this.hp, this.damage, this.armor);

  Character wound(int value) => Character(hp - value, damage, armor);
  Character heal(int value) => Character(hp + value, damage, armor);
  Character setArmor(int value) => Character(hp, damage, value);
}

abstract class SpellEffect {
  final int manaCost;

  SpellEffect(this.manaCost);
  
  GameState cast(GameState state) {
    return _castEffect(state).spendMana(manaCost);
  }

  GameState _castEffect(GameState state);

  GameState upkeep(GameState state) { return state; }
}

class MagicMissile extends SpellEffect {
  MagicMissile() : super(53);

  @override
  GameState _castEffect(GameState state) {
    return state.updateVillain(state.villain.wound(4));
  }
}

class Drain extends SpellEffect {
  Drain() : super(73);

  @override
  GameState _castEffect(GameState state) {
    return state.updatePC(state.pc.heal(2)).updateVillain(state.villain.wound(2));
  }
}

class Shield extends SpellEffect {
  Shield() : super(113);

  @override
  GameState _castEffect(GameState state) {
    return state.addSpellEffect(this, 6);
  }

  @override
  GameState upkeep(GameState state) {
    return state.updatePC(state.pc.setArmor(7));
  }
}

class Poison extends SpellEffect {
  Poison() : super(173);

  @override
  GameState _castEffect(GameState state) {
    return state.addSpellEffect(this, 6);
  }

  @override
  GameState upkeep(GameState state) {
    return state.updateVillain(state.villain.wound(3));
  }
}

class Recharge extends SpellEffect {
  Recharge() : super(229);

  @override
  GameState _castEffect(GameState state) {
    return state.addSpellEffect(this, 5);
  }

  @override
  GameState upkeep(GameState state) {
    return state.rechargeMana(101);
  }
}

class GameState {
  final Character pc;
  final Character villain;
  final List<(SpellEffect effect, int turnsRemaining)> spellEffects;
  final int spentMana;
  final int availableMana;
  final bool isPlayerTurn;

  GameState(this.pc, this.villain, this.spellEffects, this.spentMana, this.availableMana, this.isPlayerTurn);

  GameState updatePC(Character newPc) => GameState(newPc, villain, spellEffects, spentMana, availableMana, isPlayerTurn);
  GameState updateVillain(Character newVillain) => GameState(pc, newVillain, spellEffects, spentMana, availableMana, isPlayerTurn);
  GameState addSpellEffect(SpellEffect spell, int turns) => GameState(pc, villain, spellEffects + [(spell, turns)], spentMana, availableMana, isPlayerTurn);
  GameState rechargeMana(int value) => GameState(pc, villain, spellEffects, spentMana, availableMana + value, isPlayerTurn);
  GameState spendMana(int value) => GameState(pc, villain, spellEffects, spentMana + value, availableMana - value, isPlayerTurn);

  GameState villainDealsDamage() => updatePC(pc.wound([1, villain.damage - pc.armor].max));

  GameState upkeep() {
    final next = spellEffects.fold(updatePC(pc.setArmor(0)), (previous, current) => current.$1.upkeep(previous));
    final nextSE = next.spellEffects.map((it) => (it.$1, it.$2 - 1)).where((it) => it.$2 > 0).toList();

    return GameState(next.pc, next.villain, nextSE, next.spentMana, next.availableMana, next.isPlayerTurn);
  }

  GameState endTurn() {
    return GameState(pc, villain, spellEffects, spentMana, availableMana, !isPlayerTurn);
  }
}


Future<void> main() async {
  final data = await getInput('day22');
  final temp = data.lines().map((line) => line.split(':')[1]).map(int.parse).toList();
  final villain = Character(temp[0], temp[1], 0);

  final current = GameState(Character(50, 0, 0), villain, [], 0, 500, true);
  test(do1(current, false), 900);
  test(do1(current, true), 1216);

}

int do1(GameState state, bool hardMode) {
  final open = PriorityQueue<GameState>((gs1, gs2) => gs1.spentMana - gs2.spentMana);
  open.add(state);
  final spells = [MagicMissile(), Drain(), Shield(), Poison(), Recharge()];

  while (open.isNotEmpty) {
    final first = open.removeFirst();
    final second = (hardMode && first.isPlayerTurn) ? first.updatePC(first.pc.wound(1)) : first;
    if (second.pc.hp <= 0) continue;
    final current = second.upkeep();
    if (current.villain.hp <= 0) {
      return current.spentMana;
    }

    if (current.isPlayerTurn) {
      for(final spell in spells.where((spell) => !current.spellEffects.map((it)=>it.$1).contains(spell)).where((spell) => spell.manaCost <= current.availableMana)) {
        open.add(spell.cast(current).endTurn());
      }
    } else {
      final next = current.villainDealsDamage();
      if (next.pc.hp > 0) {
        open.add(next.endTurn());
      }
    }
  }

  throw Exception('wut?');
}