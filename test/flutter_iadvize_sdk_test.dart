import 'dart:async';

import 'package:flutter_iadvize_sdk/flutter_iadvize_sdk.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_method_channel.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIadvizeSdkPlatform
    with MockPlatformInterfaceMixin
    implements IadvizeSdkPlatform {
  @override
  Future<bool> activate(int projectId, String? userId, String? gdprUrl) =>
      Future<bool>.value(true);

  @override
  void setLogLevel(LogLevel logLevel) {}

  @override
  void setLanguage(String language) {}

  @override
  Future<bool> disablePushNotifications() => Future<bool>.value(true);

  @override
  Future<bool> enablePushNotifications() => Future<bool>.value(true);

  @override
  Stream<String> get onHandleClickedUrl {
    StreamController<String> controller =
        StreamController<String>.broadcast(sync: false);
    controller.add('test');
    return controller.stream.cast();
  }

  @override
  Stream<bool> get onOngoingConversationUpdated {
    StreamController<bool> controller =
        StreamController<bool>.broadcast(sync: false);
    controller.add(true);
    return controller.stream.cast();
  }

  @override
  Future<bool> isActiveTargetingRuleAvailable() => Future<bool>.value(true);

  @override
  void logout() {}

  @override
  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated {
    StreamController<bool> controller =
        StreamController<bool>.broadcast(sync: false);
    controller.add(true);
    return controller.stream.cast();
  }

  @override
  Stream<String> get onReceiveNewMessage {
    StreamController<String> controller =
        StreamController<String>.broadcast(sync: false);
    controller.add('test');
    return controller.stream.cast();
  }

  @override
  Future<ConversationChannel?> ongoingConversationChannel() =>
      Future<ConversationChannel>.value(ConversationChannel.chat);

  @override
  Future<String?> ongoingConversationId() => Future<String>.value('testId');

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
  void setDefaultFloatingButton(bool active) {}

  @override
  void setFloatingButtonPosition(int leftMargin, int bottomMargin) {}

  @override
  void setOnActiveTargetingRuleAvailabilityListener() {}

  @override
  void activateTargetingRule(TargetingRule targetingRule) {}

  @override
  void dissmissChatbox() {}

  @override
  Future<bool> isChatboxPresented() => Future<bool>.value(true);

  @override
  Future<bool> isSDKActivated() => Future<bool>.value(true);

  @override
  void presentChatbox() {}

  @override
  void setConversationListener(bool manageUrlClick) {}
}

void main() {
  final IadvizeSdkPlatform initialPlatform = IadvizeSdkPlatform.instance;

  test('$MethodChannelIadvizeSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIadvizeSdk>());
  });

  test('activate', () async {
    MockFlutterIadvizeSdkPlatform fakePlatform =
        MockFlutterIadvizeSdkPlatform();
    IadvizeSdkPlatform.instance = fakePlatform;

    expect(await IAdvizeSdk.activate(projectId: 0), true);
  });
}
