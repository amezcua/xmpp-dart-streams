import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:xmpp_dart_streams/src/messages/Parsing.dart';
import 'package:xmpp_dart_streams/src/messages/ServerMessage.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/iq.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

class SessionInitiated extends ServerMessage {

  static final ServerMessageParser parse = (String rawMessage) {

    try {
      final parsed = xml.parse(rawMessage);

      if (isIqResult(parsed)) {
        return _inspectSessionResult(parsed);
      } else {
        return null;
      }
    } on XmlParserException {
      return null;
    }
  };

  static SessionInitiated _inspectSessionResult(xml.XmlDocument parsed) {
    final sessionContent = parsed.findAllElements('session', namespace: XMPP_SESSION);
    if (sessionContent.isEmpty) {
      return null;
    } else {
      return SessionInitiated();
    }
  }
}
