import 'package:crypto/crypto.dart';

import 'KnownAuthMechanisms.dart';
import 'ScramAuthMechanism.dart';

class ScramSHA1AuthMechanism extends ScramAuthMechanism {
  ScramSHA1AuthMechanism() : super(KnownAuthMechanisms.scram_sha_1, sha1);
}