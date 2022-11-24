enum ApplicationMode {
  dev,
  prod,
}

extension ParseToString on ApplicationMode {
  String toValueString() {
    return toString().split('.').last;
  }
}
