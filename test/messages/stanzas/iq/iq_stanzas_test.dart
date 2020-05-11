import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/stream/messages/ResourceBound.dart';

void main() {
  final userId = 'aUserName';
  final hostName = 'aHost';
  final resourceId = 'aResourceId';
  var boundResourceXml = "<iq id='bindId' type='result'><bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'><jid>$userId@$hostName/$resourceId</jid></bind></iq>";

  test('Bound resource can be parsed correctly', () {
    final ResourceBound parsed = ResourceBound.parse(boundResourceXml);

    expect(parsed.jid.userId, equals(userId));
    expect(parsed.jid.host, equals(hostName));
    expect(parsed.jid.resourceId, equals(resourceId));
  });
}