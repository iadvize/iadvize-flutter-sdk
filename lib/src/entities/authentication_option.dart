import 'package:iadvize_flutter_sdk/src/enums/authentication_option_type.dart';

class AuthenticationOption {
  AuthenticationOption._();

  factory AuthenticationOption.anonymous() => Anonymous();
  factory AuthenticationOption.simple({required String userId}) =>
      Simple(userId);
  factory AuthenticationOption.secured(
          {required Future<String> Function() onJweRequested}) =>
      Secured(onJweRequested);

  AuthenticationOptionType get type => AuthenticationOptionType.anonymous;
}

class Anonymous extends AuthenticationOption {
  Anonymous() : super._();
}

class Simple extends AuthenticationOption {
  Simple(this.userId) : super._();
  final String userId;

  @override
  AuthenticationOptionType get type => AuthenticationOptionType.simple;
}

class Secured extends AuthenticationOption {
  Secured(this.onJweRequested) : super._();
  final Future<String> Function() onJweRequested;

  @override
  AuthenticationOptionType get type => AuthenticationOptionType.secured;
}
