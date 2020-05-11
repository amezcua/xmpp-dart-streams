
import '../../../jid.dart';
import 'Message.dart';
import 'MessageTypes.dart';

class ChatMessage extends Message {
  ChatMessage(String body, Jid to) : super(MessageType.chat, body, to);
}