import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_method_channel.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIadvizeSdkPlatform
    with MockPlatformInterfaceMixin
    implements IadvizeSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future<String>.value('42');

  @override
  Future<bool> activate(int projectId, String? userId, String? gdprUrl) {
    throw UnimplementedError();
  }

  @override
  void setLogLevel(LogLevel logLevel) {
    throw UnimplementedError();
  }

  @override
  void activateTargetingRule(
      String uuid, ConversationChannel conversationChannel) {
    throw UnimplementedError();
  }

  @override
  void setLanguage(String language) {
    throw UnimplementedError();
  }
}

void main() {
  final IadvizeSdkPlatform initialPlatform = IadvizeSdkPlatform.instance;

  test('$MethodChannelIadvizeSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIadvizeSdk>());
  });

  test('getPlatformVersion', () async {
    IavizeSdk flutterIadvizeSdkPlugin = IavizeSdk();
    MockFlutterIadvizeSdkPlatform fakePlatform =
        MockFlutterIadvizeSdkPlatform();
    IadvizeSdkPlatform.instance = fakePlatform;

    expect(await flutterIadvizeSdkPlugin.getPlatformVersion(), '42');
  });
}
