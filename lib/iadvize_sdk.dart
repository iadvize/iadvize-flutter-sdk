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
      {required int projectId, String? userId, String? gdprUrl}) {
    return IadvizeSdkPlatform.instance.activate(projectId, userId, gdprUrl);
  }

  void setLogLevel(LogLevel logLevel) {
    return IadvizeSdkPlatform.instance.setLogLevel(logLevel);
  }

  void setLanguage(String language) {
    return IadvizeSdkPlatform.instance.setLanguage(language);
  }

  void activateTargetingRule({
    required String uuid,
    required ConversationChannel conversationChannel,
  }) {
    return IadvizeSdkPlatform.instance
        .activateTargetingRule(uuid, conversationChannel);
  }

  Future<bool> isActiveTargetingRuleAvailable() =>
      IadvizeSdkPlatform.instance.isActiveTargetingRuleAvailable();
}
