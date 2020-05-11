import 'package:crypto/crypto.dart';

import 'KnownAuthMechanisms.dart';
import 'ScramAuthMechanism.dart';

class ScramSHA256AuthMechanism extends ScramAuthMechanism {
  ScramSHA256AuthMechanism() : super(KnownAuthMechanisms.scram_sha_256, sha256);
}