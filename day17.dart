import 'package:collection/collection.dart';

import 'utils/input.dart';
import 'utils/my_extensions.dart';
import 'utils/test.dart';


Future<void> main() async {
  final sample = [20, 15, 10, 5, 5];
  final data = (await getInput('day17')).lines().map(int.parse).toList();

  final sampleResult = do1(sample, 25, []);
  final sampleResultMin = sampleResult.map((l) => l.length).min;
  test(sampleResult.length, 4);
  test(sampleResult.where((l) => l.length == sampleResultMin).length, 3);

  final dataResult = do1(data, 150, []);
  final dataResultMin = dataResult.map((l) => l.length).min;
  test(dataResult.length, 1638);
  test(dataResult.where((l) => l.length == dataResultMin).length, 17);

}

List<List<int>> do1(List<int> remainingContainers, int liters, List<int> usedContainers) {
  if (liters == 0) return [usedContainers];
  if (remainingContainers.isEmpty) return [];
  return do1(remainingContainers.sublist(1), liters, usedContainers) +
    do1(remainingContainers.sublist(1), liters - remainingContainers[0], usedContainers + [remainingContainers[0]]);
}