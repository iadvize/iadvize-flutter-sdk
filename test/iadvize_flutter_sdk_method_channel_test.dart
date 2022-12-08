import 'package:flutter/services.dart';
import 'package:iadvize_flutter_sdk/iadvize_flutter_sdk.dart';
import 'package:iadvize_flutter_sdk/src/iadvize_sdk_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelIadvizeSdk platform = MethodChannelIadvizeSdk();
  const MethodChannel channel = MethodChannel('iadvize_flutter_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('activate', () async {
    expect(await platform.activate(0, AuthenticationOption.anonymous(), null),
        true);
  });
}
