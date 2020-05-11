import 'package:equatable/equatable.dart';
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';

import 'Auth.dart';
import 'KnownAuthMechanisms.dart';

abstract class AuthMechanism extends Equatable {

  final KnownAuthMechanisms _knownAuthMechanism;

  String get name  => _knownAuthMechanism.getName();
  int get preference => _knownAuthMechanism.findPreference();

  AuthMechanism(this._knownAuthMechanism);

  @override
  List<Object> get props => [_knownAuthMechanism, name, preference];

  AuthMessage buildAuthMessage(Auth auth);
}