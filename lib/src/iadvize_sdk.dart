import 'package:flutter_iadvize_sdk/src/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/src/entities/targeting_rule.dart';
import 'package:flutter_iadvize_sdk/src/entities/transaction.dart';
import 'package:flutter_iadvize_sdk/src/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/src/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/src/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/src/enums/navigation_option.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_platform_interface.dart';

class IAdvizeSdk {
  /// Activate the iAdvize Conversation SDK.
  ///
  /// [projectId] The name of the flag.
  /// [userId] allows logged in user to retrieve his conversation history
  /// [gdprUrl] is used to get the visitor consent on GDPR before he starts chatting
  /// Returns [bool] if SDK activated or not
  static Future<bool> activate({
    required int projectId,
    String? userId,
    String? gdprUrl,
  }) =>
      IadvizeSdkPlatform.instance.activate(projectId, userId, gdprUrl);

  /// Displaying logs
  ///
  ///Provide [logLevel] to define what log the SDK should display
  static void setLogLevel(LogLevel logLevel) =>
      IadvizeSdkPlatform.instance.setLogLevel(logLevel);

  /// Setup the SDK language
  /// By default, the targeting rule language used is the user’s device current language
  ///
  /// Provide [language] to setup language
  static void setLanguage(String language) =>
      IadvizeSdkPlatform.instance.setLanguage(language);

  /// Using a targeting rule, you can engage a user
  ///
  /// Provide the [targetingRule] to activate
  static void activateTargetingRule(
    TargetingRule targetingRule,
  ) =>
      IadvizeSdkPlatform.instance.activateTargetingRule(targetingRule);

  /// Get the SDK active rule availability
  ///
  static Future<bool> isActiveTargetingRuleAvailable() =>
      IadvizeSdkPlatform.instance.isActiveTargetingRuleAvailable();

  /// Activate listener for the SDK active rule availability change
  ///
  static void setOnActiveTargetingRuleAvailabilityListener() =>
      IadvizeSdkPlatform.instance
          .setOnActiveTargetingRuleAvailabilityListener();

  /// [Stream] of active rule availability change
  ///
  static Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      IadvizeSdkPlatform.instance.onActiveTargetingRuleAvailabilityUpdated;

  /// Register the user navigation through your app
  ///
  /// you must provide [newTargetingRule] if [navigationOption] is [NavigationOption.optionNew]
  static void registerUserNavigation({
    required NavigationOption navigationOption,
    TargetingRule? newTargetingRule,
  }) {
    assert(() {
      if (navigationOption == NavigationOption.optionNew &&
          newTargetingRule == null) {
        return false;
      }
      return true;
    }());
    IadvizeSdkPlatform.instance
        .registerUserNavigation(navigationOption, newTargetingRule);
  }

  /// Get the ongoing conversation id
  static Future<String?> ongoingConversationId() =>
      IadvizeSdkPlatform.instance.ongoingConversationId();

  /// Get the ongoing conversation [ConversationChannel]
  static Future<ConversationChannel?> ongoingConversationChannel() =>
      IadvizeSdkPlatform.instance.ongoingConversationChannel();

  /// Activate listener for conversation
  ///
  /// Put [manageUrlClick] to true if you want your app handle url click
  static void setConversationListener({bool manageUrlClick = false}) =>
      IadvizeSdkPlatform.instance.setConversationListener(manageUrlClick);

  /// [Stream] of received message
  ///
  static Stream<String> get onReceiveNewMessage =>
      IadvizeSdkPlatform.instance.onReceiveNewMessage;

  /// [Stream] of ongoing conversation update
  ///
  static Stream<bool> get onOngoingConversationUpdated =>
      IadvizeSdkPlatform.instance.onOngoingConversationUpdated;

  /// [Stream] of ongoing conversation update
  ///
  static Stream<String> get onHandleClickedUrl =>
      IadvizeSdkPlatform.instance.onHandleClickedUrl;

  /// Register Push token
  static void registerPushToken({
    required String pushToken,
    ApplicationMode mode = ApplicationMode.dev,
  }) =>
      IadvizeSdkPlatform.instance.registerPushToken(pushToken, mode);

  /// Enable Push notifications
  static Future<bool> enablePushNotifications() =>
      IadvizeSdkPlatform.instance.enablePushNotifications();

  /// Disable Push notifications
  static Future<bool> disablePushNotifications() =>
      IadvizeSdkPlatform.instance.disablePushNotifications();

  /// Show/Hide default Conversation button
  static void setDefaultFloatingButton(bool active) =>
      IadvizeSdkPlatform.instance.setDefaultFloatingButton(active);

  /// Define [leftMargin] and [bottomMargin] of the default button
  static void setFloatingButtonPosition({
    required int leftMargin,
    required int bottomMargin,
  }) =>
      IadvizeSdkPlatform.instance
          .setFloatingButtonPosition(leftMargin, bottomMargin);

  /// Configure chatbox
  static void setChatboxConfiguration(ChatboxConfiguration configuration) =>
      IadvizeSdkPlatform.instance.setChatboxConfiguration(configuration);

  /// Register transaction
  static void registerTransaction(Transaction transaction) =>
      IadvizeSdkPlatform.instance.registerTransaction(transaction);

  /// Logout
  static void logout() => IadvizeSdkPlatform.instance.logout();

  /// Present chatbox
  static void presentChatbox() => IadvizeSdkPlatform.instance.presentChatbox();

  /// Dismiss chatbox
  static void dissmissChatbox() =>
      IadvizeSdkPlatform.instance.dissmissChatbox();

  /// Get if chatbox is presented
  static Future<bool> isChatboxPresented() =>
      IadvizeSdkPlatform.instance.isChatboxPresented();

  /// Get if SDK is activated
  static Future<bool> isSDKActivated() =>
      IadvizeSdkPlatform.instance.isSDKActivated();
}
