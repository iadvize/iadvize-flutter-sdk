import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk_platform_interface.dart';

/// An implementation of [IadvizeSdkPlatform] that uses method channels.
class MethodChannelIadvizeSdk extends IadvizeSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_iadvize_sdk');

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
}
