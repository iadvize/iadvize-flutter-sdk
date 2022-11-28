import 'package:flutter_iadvize_sdk/iadvize_sdk.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_method_channel.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIadvizeSdkPlatform
    with MockPlatformInterfaceMixin
    implements IadvizeSdkPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future<String>.value('42');

  @override
  Future<bool> activate(int projectId, String? userId, String? gdprUrl) {
    throw UnimplementedError();
  }

  @override
  void setLogLevel(LogLevel logLevel) {
    throw UnimplementedError();
  }

  @override
  void setLanguage(String language) {
    throw UnimplementedError();
  }

  @override
  Future<bool> disablePushNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<bool> enablePushNotifications() {
    throw UnimplementedError();
  }

  @override
  Stream<String> get handleClickedUrl => throw UnimplementedError();

  @override
  Stream<bool> get hasOngoingConversation => throw UnimplementedError();

  @override
  Future<bool> isActiveTargetingRuleAvailable() {
    throw UnimplementedError();
  }

  @override
  void logout() {}

  @override
  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      throw UnimplementedError();

  @override
  Stream<String> get onReceiveNewMessage => throw UnimplementedError();

  @override
  Future<ConversationChannel?> ongoingConversationChannel() {
    throw UnimplementedError();
  }

  @override
  Future<String?> ongoingConversationId() {
    throw UnimplementedError();
  }

  @override
  void registerPushToken(String pushToken, ApplicationMode mode) {}

  @override
  void registerTransaction(Transaction transaction) {}

  @override
  void registerUserNavigation(
      NavigationOption navigationOption, TargetingRule? newTargetingRule) {}

  @override
  void setChatboxConfiguration(ChatboxConfiguration configuration) {}

  @override
  void setConversationListener() {}

  @override
  void setDefaultFloatingButton(bool active) {}

  @override
  void setFloatingButtonPosition(int leftMargin, int bottomMargin) {}

  @override
  void setOnActiveTargetingRuleAvailabilityListener() {}

  @override
  void activateTargetingRule(TargetingRule targetingRule) {}
}

void main() {
  final IadvizeSdkPlatform initialPlatform = IadvizeSdkPlatform.instance;

  test('$MethodChannelIadvizeSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIadvizeSdk>());
  });

  test('getPlatformVersion', () async {
    IadvizeSdk flutterIadvizeSdkPlugin = IadvizeSdk();
    MockFlutterIadvizeSdkPlatform fakePlatform =
        MockFlutterIadvizeSdkPlatform();
    IadvizeSdkPlatform.instance = fakePlatform;

    // expect(await flutterIadvizeSdkPlugin.getPlatformVersion(), '42');
  });
}
