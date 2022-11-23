import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    try {
      return await methodChannel.invokeMethod<bool>(
            'activate',
            <String, dynamic>{
              'projectId': projectId,
              'userId': userId,
              'gdprUrl': gdprUrl
            },
          ) ??
          false;
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: error');
      return false;
    }
  }

  @override
  void setLogLevel(LogLevel logLevel) {
    try {
      methodChannel.invokeMethod(
        'setLogLevel',
        <String, dynamic>{
          'logLevel': logLevel.code,
        },
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: setLogLevel error');
    }
  }

  @override
  void setLanguage(String language) {
    try {
      methodChannel.invokeMethod(
        'setLanguage',
        <String, dynamic>{
          'language': language,
        },
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: setLanguage error');
    }
  }

  @override
  void activateTargetingRule(
    String uuid,
    ConversationChannel conversationChannel,
  ) {
    try {
      methodChannel.invokeMethod(
        'activateTargetingRule',
        <String, dynamic>{
          'uuid': uuid,
          'channel': conversationChannel.toString(),
        },
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: activateTargetingRule error');
    }
  }

  @override
  Future<bool> isActiveTargetingRuleAvailable() async {
    try {
      return await methodChannel.invokeMethod(
            'isActiveTargetingRuleAvailable',
            <String, dynamic>{},
          ) ??
          false;
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: isActiveTargetingRuleAvailable error');
      return false;
    }
  }

  @override
  void setOnActiveTargetingRuleAvailabilityListener() {
    try {
      methodChannel.invokeMethod(
        'setOnActiveTargetingRuleAvailabilityListener',
        <String, dynamic>{},
      );
    } on PlatformException catch (e) {
      log(e.message ??
          'iAdvize: setOnActiveTargetingRuleAvailabilityListener error');
    }
  }

  @override
  Stream<bool> get onActiveTargetingRuleAvailabilityUpdated =>
      _activeTargetingRuleAvailabilityUpdatedEventChannel
          .receiveBroadcastStream()
          .cast();

  @override
  Future<String?> ongoingConversationId() async {
    try {
      return await methodChannel.invokeMethod(
        'ongoingConversationId',
        <String, dynamic>{},
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: ongoingConversationId error');
      return null;
    }
  }

  @override
  Future<ConversationChannel?> ongoingConversationChannel() async {
    try {
      String? channel = await methodChannel.invokeMethod(
        'ongoingConversationChannel',
        <String, dynamic>{},
      );
      return ConversationChannel.values
          .firstWhereOrNull((ConversationChannel e) => e.toString() == channel);
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: ongoingConversationChannel error');
      return null;
    }
  }

  @override
  void setConversationListener() {
    try {
      methodChannel.invokeMethod(
        'setConversationListener',
        <String, dynamic>{},
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'iAdvize: setConversationListener error');
    }
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

  // @override
  // void onConversationListener({Function(String)? onReceiveNewMessage}) =>
  //     _conversationEventChannel
  //         .receiveBroadcastStream()
  //         .cast<String>()
  //         .listen((dynamic event) {
  //       if (event is String && onReceiveNewMessage != null) {
  //         onReceiveNewMessage(event);
  //       }
  //     });

  // @override
  // Stream<String> getonReceiveNewMessage() {
  //   _conversationEventChannel
  //       .receiveBroadcastStream()
  //       .where((dynamic event) => event is Map<String, dynamic> && event[''])
  //       .map((event) => null)
  //       .cast();
  // }
}
