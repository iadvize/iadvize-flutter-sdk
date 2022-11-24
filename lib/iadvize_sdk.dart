import 'package:flutter_iadvize_sdk/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_platform_interface.dart';

class IavizeSdk {
  Future<String?> getPlatformVersion() {
    return IadvizeSdkPlatform.instance.getPlatformVersion();
  }

  /// Activate the iAdvize Conversation SDK.
  /// Once this call succeeds, the iAdvize Conversation SDK is activated.
  /// IAdvizeSDK.chatboxController can be used to display the Chat Button to the user and the user can start a conversation.
  Future<bool> activate(
          {required int projectId, String? userId, String? gdprUrl}) =>
      IadvizeSdkPlatform.instance.activate(projectId, userId, gdprUrl);

  void setLogLevel(LogLevel logLevel) =>
      IadvizeSdkPlatform.instance.setLogLevel(logLevel);

  void setLanguage(String language) =>
      IadvizeSdkPlatform.instance.setLanguage(language);

  void activateTargetingRule({
    required String uuid,
    required ConversationChannel conversationChannel,
  }) =>
      IadvizeSdkPlatform.instance
          .activateTargetingRule(uuid, conversationChannel);

  Future<bool> isActiveTargetingRuleAvailable() =>
      IadvizeSdkPlatform.instance.isActiveTargetingRuleAvailable();

  void setOnActiveTargetingRuleAvailabilityListener() =>
      IadvizeSdkPlatform.instance
          .setOnActiveTargetingRuleAvailabilityListener();

  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      IadvizeSdkPlatform.instance.onActiveTargetingRuleAvailabilityUpdated;

  Future<String?> ongoingConversationId() =>
      IadvizeSdkPlatform.instance.ongoingConversationId();

  Future<ConversationChannel?> ongoingConversationChannel() =>
      IadvizeSdkPlatform.instance.ongoingConversationChannel();

  void setConversationListener() =>
      IadvizeSdkPlatform.instance.setConversationListener();

  Stream<String> get onReceiveNewMessage =>
      IadvizeSdkPlatform.instance.onReceiveNewMessage;

  Stream<bool> get hasOngoingConversation =>
      IadvizeSdkPlatform.instance.hasOngoingConversation;

  Stream<String> get handleClickedUrl =>
      IadvizeSdkPlatform.instance.handleClickedUrl;

  void registerPushToken(
          {required String pushToken,
          ApplicationMode mode = ApplicationMode.dev}) =>
      IadvizeSdkPlatform.instance.registerPushToken(pushToken, mode);

  Future<bool> enablePushNotifications() =>
      IadvizeSdkPlatform.instance.enablePushNotifications();

  Future<bool> disablePushNotifications() =>
      IadvizeSdkPlatform.instance.disablePushNotifications();

  // void onConversationListener({Function(String)? onReceiveNewMessage}) =>
  //     IadvizeSdkPlatform.instance
  //         .onConversationListener(onReceiveNewMessage: onReceiveNewMessage);
}
