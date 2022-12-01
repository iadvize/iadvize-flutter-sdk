import 'package:iadvize_flutter_sdk/src/enums/conversation_channel.dart';

class TargetingRule {
  TargetingRule({
    required this.uuid,
    required this.channel,
  });

  final String uuid;
  final ConversationChannel channel;

  Map<String, String> toMap() => <String, String>{
        'uuid': uuid,
        'channel': channel.toValueString(),
      };
}
