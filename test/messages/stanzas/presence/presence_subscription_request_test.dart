import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/jid.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/presence/PresenceSubscriptionRequest.dart';

void main() {
  test('Presence subscription is parsed correctly', () {
    final from = Jid.simple('alice', 'localhost');
    final presenceRequest =
        "<presence from='${from.toString()}' to='bob@localhost' type='subscribe'><status></status></presence>";

    final PresenceSubscriptionRequest request =
        PresenceSubscriptionRequest.parse(presenceRequest);

    expect(request.from, equals(from));
  });
}
