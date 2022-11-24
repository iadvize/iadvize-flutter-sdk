import 'package:flutter_iadvize_sdk/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_method_channel.dart';
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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> activate(int projectId, String? userId, String? gdprUrl) =>
      throw UnimplementedError('activate() has not been implemented.');

  void setLogLevel(LogLevel logLevel) =>
      throw UnimplementedError('setLogLevel() has not been implemented.');

  void setLanguage(String language) =>
      throw UnimplementedError('setLanguage() has not been implemented.');

  void activateTargetingRule(
    String uuid,
    ConversationChannel conversationChannel,
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
}
