
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';

import 'Auth.dart';
import 'AuthMechanism.dart';
import 'KnownAuthMechanisms.dart';

class UnknownAuthMechanism extends AuthMechanism {
  UnknownAuthMechanism() : super(KnownAuthMechanisms.none);

  @override
  AuthMessage buildAuthMessage(Auth auth) {
    throw UnimplementedError();
  }
}