
import 'package:xmpp_dart_streams/src/messages/Parsing.dart';
import 'package:xmpp_dart_streams/src/messages/ServerMessage.dart';

class StreamServerClosed extends ServerMessage {
  static final ServerMessageParser parse = (String rawMessage) {
    try {
      if (_isStreamEnd(rawMessage)) {
        return StreamServerClosed();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  };
  
  static bool _isStreamEnd(String message) => 
      message.endsWith('</stream:stream>');
}