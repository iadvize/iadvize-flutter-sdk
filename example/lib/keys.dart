import 'package:flutter_iadvize_sdk/flutter_iadvize_sdk.dart';

//TODO: replace by iAdvize keys
const int projectId = 1;
const String? userId = null;
const String? grpdUrl = null;
const ApplicationMode applicationMode = ApplicationMode.dev;
final TargetingRule chatTargetingRule =
    TargetingRule(uuid: 'chat-rule-id', channel: ConversationChannel.chat);
final TargetingRule videoTargetingRule =
    TargetingRule(uuid: 'video-rule-id', channel: ConversationChannel.video);
