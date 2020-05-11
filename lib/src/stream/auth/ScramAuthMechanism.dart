import 'package:crypto/crypto.dart';
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';
import 'package:xmpp_dart_streams/src/messages/auth/scram/ScramAuthRequest.dart';

import 'Auth.dart';
import 'AuthMechanism.dart';

abstract class ScramAuthMechanism extends AuthMechanism {
  final Hash hash;

  ScramAuthMechanism(name, this.hash) : super(name);

  @override
  List<Object> get props => [name, hash];

  @override
  AuthMessage buildAuthMessage(Auth auth) =>
      ScramAuthRequest(auth.jid.userId, this);
}
