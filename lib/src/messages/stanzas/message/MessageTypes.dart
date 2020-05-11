enum MessageType { chat, error, groupchat, headline, normal }

extension MessageTypeValue on MessageType {
  // ignore: missing_return
  String getValue() {
    switch (this) {
      case MessageType.chat:
        return 'chat';
      case MessageType.error:
        return 'error';
      case MessageType.groupchat:
        return 'groupchat';
      case MessageType.headline:
        return 'headline';
      case MessageType.normal:
        return 'normal';
    }
  }
}