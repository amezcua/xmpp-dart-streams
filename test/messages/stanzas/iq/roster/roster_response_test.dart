import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/roster/RosterResponse.dart';

void main() {
  test('Roster response can be parsed correctly', () {
    final rosterResponse = "<iq from='bob@localhost' to='bob@localhost/3A623E8C52B2A62D1588-268224-75768' id='' type='result'><query xmlns='jabber:iq:roster'><item subscription='to' jid='alice@localhost'/></query></iq>";

    final RosterResponse response = RosterResponse.parse(rosterResponse);

    expect(response.items.length, equals(1));
    expect(response.items.first.jid.toString(), equals('alice@localhost'));
  });
}