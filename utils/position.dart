class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  @override
  bool operator==(Object other) =>
      other is Position && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  Iterable<Position> neighbors() sync* {
    yield Position(x-1, y-1);
    yield Position(x+0, y-1);
    yield Position(x+1, y-1);
    yield Position(x-1, y);
    yield Position(x+1, y);
    yield Position(x-1, y+1);
    yield Position(x+0, y+1);
    yield Position(x+1, y+1);
  }
}
