Iterable<int> range(int count) {
  return Iterable.generate(count, (i)=>i);
}

Iterable<int> rangeFrom(int start, int excludedCieling) {
  return Iterable.generate(excludedCieling - start, (i)=>start + i);
}