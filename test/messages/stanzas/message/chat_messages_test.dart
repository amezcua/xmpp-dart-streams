import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/jid.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/message/ChatMessage.dart';

void main() {

  test('Message type, to and body are serialised correctly', () {
    final theMessage = "Don't push me";
    final to = Jid.simple('alice', 'localhost');
    final chatMessage = ChatMessage(theMessage, to);

    final serialised = chatMessage.getXml();

    expect(serialised, contains('type=\"chat\"'));
    expect(serialised, contains('to=\"$to\"'));
    expect(serialised, contains('<body>$theMessage</body>'));
  });
}