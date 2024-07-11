
int p(int n) => n * (n+1) ~/ 2;

int v(int r, int c) => p(c) + p(c+r-2) - p(c-1);

int d25(int r, int c) {
  final n = v(r,c)-1;
  var x = 20151125;
  for (final i in Iterable.generate(n)) {
    x = (x*252533)%33554393;
  }
  return x;
}

void main() {
  print(d25(3010,3019));
}