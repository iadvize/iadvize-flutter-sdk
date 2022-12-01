enum AuthenticationOptionType { anonymous, simple, secured }

extension AuthenticationOptionTypeExt on AuthenticationOptionType {
  String toValueString() {
    return toString().split('.').last;
  }
}
