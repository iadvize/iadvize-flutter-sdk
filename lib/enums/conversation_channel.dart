enum ConversationChannel {
  chat,
  video,
}

extension ConversationChannelExt on ConversationChannel {
  String toValueString() {
    return toString().split('.').last;
  }
}
