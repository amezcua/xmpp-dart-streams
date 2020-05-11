import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

import '../../../../jid.dart';
import '../../../Parsing.dart';
import '../iq.dart';
import 'Roster.dart';
import 'RosterItem.dart';

class RosterResponse extends Roster {
  final List<RosterItem> items;

  RosterResponse(this.items);

  static final ServerMessageParser parse = (String rawMessage) {
    try {
      var parsed = xml.parse(rawMessage);
      if (isIqResult(parsed)) {
        return _extractRoster(parsed);
      } else {
        return null;
      }
    } on XmlParserException {
      return null;
    }
  };

  static RosterResponse _extractRoster(xml.XmlDocument parsed) {
    var items = parsed
        .findAllElements('item')
        .map((item) => RosterItem(_extractJid(item)))
        .toList();
    return RosterResponse(items);
  }

  static Jid _extractJid(xml.XmlElement item) {
    return Jid.from(item.attributes
        .where((a) => a.name.local == 'jid')
        .toList()
        .first
        .value);
  }
}
