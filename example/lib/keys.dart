import 'package:flutter_iadvize_sdk/entities/targeting_rule.dart';
import 'package:flutter_iadvize_sdk/enums/application_mode.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';

//TODO: replace by iAdvize keys
const int projectId = 1;
const String? userId = null;
const String? grpdUrl = null;
const ApplicationMode applicationMode = ApplicationMode.dev;
final TargetingRule chatTargetingRule =
    TargetingRule(uuid: 'chat-rule-uuid', channel: ConversationChannel.chat);
final TargetingRule videoTargetingRule =
    TargetingRule(uuid: 'video-rule-uuid', channel: ConversationChannel.video);
