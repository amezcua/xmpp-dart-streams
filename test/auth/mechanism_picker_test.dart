import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/stream/auth/AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/KnownAuthMechanisms.dart';
import 'package:xmpp_dart_streams/src/stream/auth/PlainAuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/ScramSHA1AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/ScramSHA256AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/UnknownAuthMechanism.dart';

void main() {
  test('SHA 256 is the first in the list by preference', () {
    final mechanisms = <AuthMechanism>[];
    mechanisms.add(ScramSHA256AuthMechanism());
    mechanisms.add(ScramSHA1AuthMechanism());
    mechanisms.add(PlainAuthMechanism());
    mechanisms.add(UnknownAuthMechanism());

    mechanisms.sortByPreference();

    expect(mechanisms.first.name, equals(KnownAuthMechanisms.scram_sha_256.getName()));
  });

  test('SHA 1 is the first in the list by preference', () {
    final mechanisms = <AuthMechanism>[];
    mechanisms.add(ScramSHA1AuthMechanism());
    mechanisms.add(PlainAuthMechanism());
    mechanisms.add(UnknownAuthMechanism());

    mechanisms.sortByPreference();

    expect(mechanisms.first.name, equals(KnownAuthMechanisms.scram_sha_1.getName()));
  });

  test('Plain is the first in the list by preference', () {
    final mechanisms = <AuthMechanism>[];
    mechanisms.add(PlainAuthMechanism());
    mechanisms.add(UnknownAuthMechanism());

    mechanisms.sortByPreference();

    expect(mechanisms.first.name, equals(KnownAuthMechanisms.plain.getName()));
  });
}