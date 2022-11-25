enum NavigationOption {
  optionClear,
  optionKeep,
  optionNew;
}

extension NavigationOptionExtension on NavigationOption {
  String toValueString() {
    switch (this) {
      case NavigationOption.optionClear:
        return 'clear';
      case NavigationOption.optionKeep:
        return 'keep';
      case NavigationOption.optionNew:
        return 'new';
      default:
        return 'clear';
    }
  }
}
