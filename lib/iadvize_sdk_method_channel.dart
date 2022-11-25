import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iadvize_sdk/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_platform_interface.dart';

/// An implementation of [IadvizeSdkPlatform] that uses method channels.
class MethodChannelIadvizeSdk extends IadvizeSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const MethodChannel methodChannel =
      MethodChannel('flutter_iadvize_sdk');
  static final EventChannel _messageEventChannel =
      EventChannel('${methodChannel.name}/onReceiveMessage');
  static final EventChannel _clickUrlEventChannel =
      EventChannel('${methodChannel.name}/handleClickUrl');
  static final EventChannel _conversationUpdatedEventChannel =
      EventChannel('${methodChannel.name}/onOngoingConversationUpdated');
  static final EventChannel
      _activeTargetingRuleAvailabilityUpdatedEventChannel = EventChannel(
          '${methodChannel.name}/onActiveTargetingRuleAvailabilityUpdated');

  @override
  Future<bool> activate(int projectId, String? userId, String? gdprUrl) async {
    return _callNativeMethod('activate',
        arguments: <String, dynamic>{
          'projectId': projectId,
          'userId': userId,
          'gdprUrl': gdprUrl
        },
        defaultValue: false);
  }

  @override
  void setLogLevel(LogLevel logLevel) {
    _callNativeMethodVoid(
      'setLogLevel',
      arguments: <String, dynamic>{
        'logLevel': logLevel.code,
      },
    );
  }

  @override
  void setLanguage(String language) {
    _callNativeMethodVoid(
      'setLanguage',
      arguments: <String, dynamic>{
        'language': language,
      },
    );
  }

  @override
  void activateTargetingRule(
    String uuid,
    ConversationChannel conversationChannel,
  ) {
    _callNativeMethodVoid('activateTargetingRule', arguments: <String, dynamic>{
      'uuid': uuid,
      'channel': conversationChannel.toValueString(),
    });
  }

  @override
  Future<bool> isActiveTargetingRuleAvailable() async {
    return _callNativeMethod('isActiveTargetingRuleAvailable',
        defaultValue: false);
  }

  @override
  void setOnActiveTargetingRuleAvailabilityListener() {
    _callNativeMethodVoid(
      'setOnActiveTargetingRuleAvailabilityListener',
    );
  }

  @override
  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      _activeTargetingRuleAvailabilityUpdatedEventChannel
          .receiveBroadcastStream()
          .cast();

  @override
  Future<String?> ongoingConversationId() async {
    return _callNativeMethod('ongoingConversationId', defaultValue: null);
  }

  @override
  Future<ConversationChannel?> ongoingConversationChannel() async {
    final String? channel = await _callNativeMethod(
        'ongoingConversationChannel',
        defaultValue: null);
    return ConversationChannel.values.firstWhereOrNull(
        (ConversationChannel e) => e.toValueString() == channel);
  }

  @override
  void setConversationListener() {
    _callNativeMethodVoid('setConversationListener');
  }

  @override
  Stream<String> get onReceiveNewMessage =>
      _messageEventChannel.receiveBroadcastStream().cast();

  @override
  Stream<bool> get hasOngoingConversation =>
      _conversationUpdatedEventChannel.receiveBroadcastStream().cast();

  @override
  Stream<String> get handleClickedUrl =>
      _clickUrlEventChannel.receiveBroadcastStream().cast();

  @override
  void registerPushToken(String pushToken, ApplicationMode mode) {
    _callNativeMethodVoid('registerPushToken', arguments: <String, dynamic>{
      'pushToken': pushToken,
      'mode': mode.toValueString(),
    });
  }

  @override
  Future<bool> enablePushNotifications() async {
    return _callNativeMethod('enablePushNotifications', defaultValue: false);
  }

  @override
  Future<bool> disablePushNotifications() async {
    return _callNativeMethod('disablePushNotifications', defaultValue: false);
  }

  @override
  void setDefaultFloatingButton(bool active) {
    return _callNativeMethodVoid('setDefaultFloatingButton',
        arguments: <String, dynamic>{'active': active});
  }

  @override
  void setFloatingButtonPosition(int leftMargin, int bottomMargin) {
    return _callNativeMethodVoid('setFloatingButtonPosition',
        arguments: <String, dynamic>{
          'leftMargin': leftMargin,
          'bottomMargin': bottomMargin,
        });
  }

  @override
  Future<void> setChatboxConfiguration(
      ChatboxConfiguration configuration) async {
    // log(' ${await configuration.toMap()}');
    return _callNativeMethodVoid('setChatboxConfiguration',
        arguments: await configuration.toMap());
  }

  Future<T> _callNativeMethod<T>(
    String method, {
    Map<String, dynamic> arguments = const <String, dynamic>{},
    required T defaultValue,
  }) async {
    try {
      return await methodChannel.invokeMethod(
            method,
            arguments,
          ) ??
          defaultValue;
    } on PlatformException catch (e) {
      log(e.toString());
      return defaultValue;
    }
  }

  void _callNativeMethodVoid(
    String method, {
    Map<String, dynamic> arguments = const <String, dynamic>{},
  }) {
    try {
      methodChannel.invokeMethod(
        method,
        arguments,
      );
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }
}
