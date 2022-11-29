import 'package:flutter_iadvize_sdk/src/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/src/entities/targeting_rule.dart';
import 'package:flutter_iadvize_sdk/src/entities/transaction.dart';
import 'package:flutter_iadvize_sdk/src/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/src/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/src/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/src/enums/navigation_option.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_platform_interface.dart';

class IadvizeSdk {
  /// Activate the iAdvize Conversation SDK.
  /// Once this call succeeds, the iAdvize Conversation SDK is activated.
  /// IAdvizeSDK.chatboxController can be used to display the Chat Button to the user and the user can start a conversation.
  static Future<bool> activate({
    required int projectId,
    String? userId,
    String? gdprUrl,
  }) =>
      IadvizeSdkPlatform.instance.activate(projectId, userId, gdprUrl);

  static void setLogLevel(LogLevel logLevel) =>
      IadvizeSdkPlatform.instance.setLogLevel(logLevel);

  static void setLanguage(String language) =>
      IadvizeSdkPlatform.instance.setLanguage(language);

  static void activateTargetingRule(
    TargetingRule targetingRule,
  ) =>
      IadvizeSdkPlatform.instance.activateTargetingRule(targetingRule);

  static Future<bool> isActiveTargetingRuleAvailable() =>
      IadvizeSdkPlatform.instance.isActiveTargetingRuleAvailable();

  static void setOnActiveTargetingRuleAvailabilityListener() =>
      IadvizeSdkPlatform.instance
          .setOnActiveTargetingRuleAvailabilityListener();

  static Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      IadvizeSdkPlatform.instance.onActiveTargetingRuleAvailabilityUpdated;

  static void registerUserNavigation({
    required NavigationOption navigationOption,
    TargetingRule? newTargetingRule,
  }) =>
      IadvizeSdkPlatform.instance
          .registerUserNavigation(navigationOption, newTargetingRule);

  static Future<String?> ongoingConversationId() =>
      IadvizeSdkPlatform.instance.ongoingConversationId();

  static Future<ConversationChannel?> ongoingConversationChannel() =>
      IadvizeSdkPlatform.instance.ongoingConversationChannel();

  static void setConversationListener({bool manageUrlClick = false}) =>
      IadvizeSdkPlatform.instance.setConversationListener(manageUrlClick);

  static Stream<String> get onReceiveNewMessage =>
      IadvizeSdkPlatform.instance.onReceiveNewMessage;

  static Stream<bool> get onOngoingConversationUpdated =>
      IadvizeSdkPlatform.instance.onOngoingConversationUpdated;

  static Stream<String> get onHandleClickedUrl =>
      IadvizeSdkPlatform.instance.onHandleClickedUrl;

  static void registerPushToken({
    required String pushToken,
    ApplicationMode mode = ApplicationMode.dev,
  }) =>
      IadvizeSdkPlatform.instance.registerPushToken(pushToken, mode);

  static Future<bool> enablePushNotifications() =>
      IadvizeSdkPlatform.instance.enablePushNotifications();

  static Future<bool> disablePushNotifications() =>
      IadvizeSdkPlatform.instance.disablePushNotifications();

  static void setDefaultFloatingButton(bool active) =>
      IadvizeSdkPlatform.instance.setDefaultFloatingButton(active);

  static void setFloatingButtonPosition({
    required int leftMargin,
    required int bottomMargin,
  }) =>
      IadvizeSdkPlatform.instance
          .setFloatingButtonPosition(leftMargin, bottomMargin);

  static void setChatboxConfiguration(ChatboxConfiguration configuration) =>
      IadvizeSdkPlatform.instance.setChatboxConfiguration(configuration);

  static void registerTransaction(Transaction transaction) =>
      IadvizeSdkPlatform.instance.registerTransaction(transaction);

  static void logout() => IadvizeSdkPlatform.instance.logout();

  static void presentChatbox() => IadvizeSdkPlatform.instance.presentChatbox();

  static void dissmissChatbox() =>
      IadvizeSdkPlatform.instance.dissmissChatbox();

  static Future<bool> isChatboxPresented() =>
      IadvizeSdkPlatform.instance.isChatboxPresented();

  static Future<bool> isSDKActivated() =>
      IadvizeSdkPlatform.instance.isSDKActivated();
}
