
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';
import 'package:xmpp_dart_streams/src/messages/auth/PlainAuthMessage.dart';

import 'Auth.dart';
import 'AuthMechanism.dart';
import 'KnownAuthMechanisms.dart';

class PlainAuthMechanism extends AuthMechanism {
  PlainAuthMechanism() : super(KnownAuthMechanisms.plain);

  @override
  List<Object> get props => [name];

  @override
  AuthMessage buildAuthMessage(Auth auth) =>
      PlainAuthMessage(auth.jid.userId, auth.password, auth.jid.host, this);
}
