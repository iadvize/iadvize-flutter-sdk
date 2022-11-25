import 'package:flutter/services.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelIadvizeSdk platform = MethodChannelIadvizeSdk();
  const MethodChannel channel = MethodChannel('flutter_iadvize_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}
