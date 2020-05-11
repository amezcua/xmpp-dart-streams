import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/messages/Parsing.dart';
import 'package:xmpp_dart_streams/src/messages/ServerMessage.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/iq.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../../jid.dart';

class ResourceBound extends ServerMessage {

  final Jid jid;

  ResourceBound(this.jid);

  static final ServerMessageParser parse = (String rawMessage) {
    final parsed = xml.parse(rawMessage);

    if (isIqResult(parsed)) {
      return _inspectBindResult(parsed);
    } else {
      return null;
    }
  };

  static ResourceBound _inspectBindResult(xml.XmlDocument parsed) {
    final bindContent = parsed.findAllElements('bind', namespace: XMPP_BIND);
    if (bindContent.isEmpty) {
      return null;
    } else {
      final jid = bindContent.first.findElements('jid');
      if (jid.isEmpty) {
        return null;
      } else {
        final jidRegEx = RegExp('(.*)@(.*)/(.*)');
        final matches = jidRegEx.allMatches(jid.first.text);
        return ResourceBound(Jid(matches.first.group(1), matches.first.group(2), matches.first.group(3)));
      }
    }
  }
}
