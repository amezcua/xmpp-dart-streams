
import 'AuthMechanism.dart';
import 'PlainAuthMechanism.dart';
import 'ScramSHA1AuthMechanism.dart';
import 'ScramSHA256AuthMechanism.dart';
import 'UnknownAuthMechanism.dart';

enum KnownAuthMechanisms { none, plain, scram_sha_1, scram_sha_256 }

int _scramSha256Preference = 1;
String _scramSha256 = 'SCRAM-SHA-256';
int _scramSha1Preference = 2;
String _scramSha1 = 'SCRAM-SHA-1';
int _plainPreference = 3;
String _plain = 'PLAIN';
int _unknownPreference = 100;

KnownAuthMechanisms findFromText(String text) {
  if (text == _plain) {
    return KnownAuthMechanisms.plain;
  } else if (text == _scramSha1) {
    return KnownAuthMechanisms.scram_sha_1;
  } else if (text == _scramSha256) {
    return KnownAuthMechanisms.scram_sha_256;
  } else {
    return KnownAuthMechanisms.none;
  }
}

extension KnownAuthMechanismsExt on KnownAuthMechanisms {
  String getName() {
    switch (this) {
      case KnownAuthMechanisms.plain:
        return _plain;

      case KnownAuthMechanisms.scram_sha_1:
        return _scramSha1;

      case KnownAuthMechanisms.scram_sha_256:
        return _scramSha256;

      default:
        return null;
    }
  }

  int findPreference() {
    switch (this) {
      case KnownAuthMechanisms.plain:
        return _plainPreference;

      case KnownAuthMechanisms.scram_sha_1:
        return _scramSha1Preference;

      case KnownAuthMechanisms.scram_sha_256:
        return _scramSha256Preference;

      default:
        return _unknownPreference;
    }
  }
}

AuthMechanism findAuthMechanismByName(String name) {
  final knownAuthMechanism = findFromText(name);

  switch (knownAuthMechanism) {
    case KnownAuthMechanisms.plain:
        return PlainAuthMechanism();

    case KnownAuthMechanisms.scram_sha_1:
        return ScramSHA1AuthMechanism();

    case KnownAuthMechanisms.scram_sha_256:
        return ScramSHA256AuthMechanism();

    default:
        return UnknownAuthMechanism();
  }
}

extension AuthMechanismList on List<AuthMechanism> {
  List<AuthMechanism> sortByPreference() {
    sort((am1, am2) => am1.preference.compareTo(am2.preference));
    return this;
  }
}
