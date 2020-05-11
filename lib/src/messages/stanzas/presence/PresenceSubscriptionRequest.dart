import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

import '../../../jid.dart';
import '../../Parsing.dart';
import 'Presence.dart';

///
/// Presence subscription request from user
///
class PresenceSubscriptionRequest extends Presence {
  final Jid from;

  PresenceSubscriptionRequest(this.from);

  static final ServerMessageParser parse = (String rawMessage) {
    try {
      final parsed = xml.parse(rawMessage);
      return _buildFromParsed(parsed);
    } on XmlParserException {
      return null;
    }
  };

  static PresenceSubscriptionRequest _buildFromParsed(xml.XmlDocument request) {
    final xml.XmlElement presenceElement = request.children.first;
    final isSubscribeRequest = (presenceElement.name.local == 'presence') &&
        (presenceElement.attributes
                .where((a) => a.name.local == 'type')
                .toList()
                .first
                .value ==
            'subscribe');

    if (isSubscribeRequest) {
      final from = presenceElement.attributes
          .where((a) => a.name.local == 'from')
          .toList()
          .first
          .value;
      return PresenceSubscriptionRequest(Jid.from(from));
    } else {
      return null;
    }
  }
}
