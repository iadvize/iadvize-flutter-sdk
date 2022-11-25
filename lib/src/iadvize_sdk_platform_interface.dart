import 'package:flutter_iadvize_sdk/src/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/src/entities/targeting_rule.dart';
import 'package:flutter_iadvize_sdk/src/entities/transaction.dart';
import 'package:flutter_iadvize_sdk/src/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/src/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/src/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/src/enums/navigation_option.dart';
import 'package:flutter_iadvize_sdk/src/iadvize_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class IadvizeSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterIadvizeSdkPlatform.
  IadvizeSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static IadvizeSdkPlatform _instance = MethodChannelIadvizeSdk();

  /// The default instance of [IadvizeSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIadvizeSdk].
  static IadvizeSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IadvizeSdkPlatform] when
  /// they register themselves.
  static set instance(IadvizeSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> activate(int projectId, String? userId, String? gdprUrl) =>
      throw UnimplementedError('activate() has not been implemented.');

  void setLogLevel(LogLevel logLevel) =>
      throw UnimplementedError('setLogLevel() has not been implemented.');

  void setLanguage(String language) =>
      throw UnimplementedError('setLanguage() has not been implemented.');

  void activateTargetingRule(
    TargetingRule targetingRule,
  ) =>
      throw UnimplementedError(
          'activateTargetingRule() has not been implemented.');

  Future<bool> isActiveTargetingRuleAvailable() => throw UnimplementedError(
      'isActiveTargetingRuleAvailable() has not been implemented.');

  void setOnActiveTargetingRuleAvailabilityListener() => throw UnimplementedError(
      'setOnActiveTargetingRuleAvailabilityListener() has not been implemented.');

  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      throw UnimplementedError(
          'onActiveTargetingRuleAvailabilityUpdated has not been implemented.');

  void registerUserNavigation(
          NavigationOption navigationOption, TargetingRule? newTargetingRule) =>
      throw UnimplementedError(
          'registerUserNavigation() has not been implemented.');

  Future<String?> ongoingConversationId() => throw UnimplementedError(
      'ongoingConversationId has not been implemented.');

  Future<ConversationChannel?> ongoingConversationChannel() =>
      throw UnimplementedError(
          'ongoingConversationChannel has not been implemented.');

  void setConversationListener() => throw UnimplementedError(
      'setConversationListener() has not been implemented.');

  Stream<String> get onReceiveNewMessage =>
      throw UnimplementedError('onReceiveNewMessage has not been implemented.');

  Stream<bool> get hasOngoingConversation => throw UnimplementedError(
      'onOngoingConversationUpdated has not been implemented.');

  Stream<String> get handleClickedUrl =>
      throw UnimplementedError('handleClickedUrl has not been implemented.');

  void registerPushToken(String pushToken, ApplicationMode mode) =>
      throw UnimplementedError('registerPushToken() has not been implemented.');

  Future<bool> enablePushNotifications() => throw UnimplementedError(
      'enablePushNotifications() has not been implemented.');

  Future<bool> disablePushNotifications() => throw UnimplementedError(
      'disablePushNotifications() has not been implemented.');

  void setDefaultFloatingButton(bool active) => throw UnimplementedError(
      'setDefaultFloatingButton() has not been implemented.');

  void setFloatingButtonPosition(int leftMargin, int bottomMargin) =>
      throw UnimplementedError(
          'setDefaultFloatingButton() has not been implemented.');

  void setChatboxConfiguration(ChatboxConfiguration configuration) =>
      throw UnimplementedError(
          'setChatboxConfiguration() has not been implemented.');

  void registerTransaction(Transaction transaction) => throw UnimplementedError(
      'registerTransaction() has not been implemented.');

  void logout() =>
      throw UnimplementedError('logout() has not been implemented.');
}
