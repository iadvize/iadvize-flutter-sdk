enum ApplicationMode {
  dev,
  prod,
}

extension ApplicationModeExt on ApplicationMode {
  String toValueString() {
    return toString().split('.').last;
  }
}
