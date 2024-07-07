void checkAnswer<T extends A, A>(T actual, A expected) {
  if (expected != actual) {
    print("    Error! $actual != $expected");
  } else {
    print("    $actual");
  }
}