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


Future<void> main() async {
  final data = await getInput('day22');
  final temp = data.lines().map((line) => line.split(':')[1]).map(int.parse).toList();
  final villain = Character(temp[0], temp[1], 0);

}