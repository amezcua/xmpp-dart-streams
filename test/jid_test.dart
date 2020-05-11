import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/jid.dart';

void main() {

  test('Invalid jid can not be parsed', () {
    final jidString = 'an invalid jid';

    expect(() => jidString.parse(), throwsArgumentError);
  });

  test('Simple Jid parsed correctly', () {
    final userId = 'bob';
    final host = 'localhost';
    final jidString = '$userId@$host';

    final jid = jidString.parse();

    expect(jid.userId, equals(userId));
    expect(jid.host, equals(host));
  });

  test('Complete Jid parsed correctly', () {
    final userId = 'bob';
    final host = 'localhost';
    final resourceId = 'resId';
    final jidString = '$userId@$host/$resourceId';

    final jid = jidString.parse();

    expect(jid.userId, equals(userId));
    expect(jid.host, equals(host));
    expect(jid.resourceId, equals(resourceId));
  });
}