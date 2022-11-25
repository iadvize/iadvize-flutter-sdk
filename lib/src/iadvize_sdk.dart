import 'package:flutter_iadvize_sdk/src/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/src/entities/targeting_rule.dart';
import 'package:flutter_iadvize_sdk/src/entities/transaction.dart';
import 'package:flutter_iadvize_sdk/src/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/src/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/src/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/src/enums/navigation_option.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_platform_interface.dart';

class IavizeSdk {
  /// Activate the iAdvize Conversation SDK.
  /// Once this call succeeds, the iAdvize Conversation SDK is activated.
  /// IAdvizeSDK.chatboxController can be used to display the Chat Button to the user and the user can start a conversation.
  Future<bool> activate({
    required int projectId,
    String? userId,
    String? gdprUrl,
  }) =>
      IadvizeSdkPlatform.instance.activate(projectId, userId, gdprUrl);

  void setLogLevel(LogLevel logLevel) =>
      IadvizeSdkPlatform.instance.setLogLevel(logLevel);

  void setLanguage(String language) =>
      IadvizeSdkPlatform.instance.setLanguage(language);

  void activateTargetingRule(
    TargetingRule targetingRule,
  ) =>
      IadvizeSdkPlatform.instance.activateTargetingRule(targetingRule);

  Future<bool> isActiveTargetingRuleAvailable() =>
      IadvizeSdkPlatform.instance.isActiveTargetingRuleAvailable();

  void setOnActiveTargetingRuleAvailabilityListener() =>
      IadvizeSdkPlatform.instance
          .setOnActiveTargetingRuleAvailabilityListener();

  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      IadvizeSdkPlatform.instance.onActiveTargetingRuleAvailabilityUpdated;

  void registerUserNavigation({
    required NavigationOption navigationOption,
    TargetingRule? newTargetingRule,
  }) =>
      IadvizeSdkPlatform.instance
          .registerUserNavigation(navigationOption, newTargetingRule);

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

  void registerPushToken({
    required String pushToken,
    ApplicationMode mode = ApplicationMode.dev,
  }) =>
      IadvizeSdkPlatform.instance.registerPushToken(pushToken, mode);

  Future<bool> enablePushNotifications() =>
      IadvizeSdkPlatform.instance.enablePushNotifications();

  Future<bool> disablePushNotifications() =>
      IadvizeSdkPlatform.instance.disablePushNotifications();

  void setDefaultFloatingButton(bool active) =>
      IadvizeSdkPlatform.instance.setDefaultFloatingButton(active);

  void setFloatingButtonPosition({
    required int leftMargin,
    required int bottomMargin,
  }) =>
      IadvizeSdkPlatform.instance
          .setFloatingButtonPosition(leftMargin, bottomMargin);

  void setChatboxConfiguration(ChatboxConfiguration configuration) =>
      IadvizeSdkPlatform.instance.setChatboxConfiguration(configuration);

  void registerTransaction(Transaction transaction) =>
      IadvizeSdkPlatform.instance.registerTransaction(transaction);

  void logout() => IadvizeSdkPlatform.instance.logout();
}
