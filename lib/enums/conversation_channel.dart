enum ConversationChannel {
  chat,
  video,
}

extension ParseToString on ConversationChannel {
  String toValueString() {
    return toString().split('.').last;
  }
}
