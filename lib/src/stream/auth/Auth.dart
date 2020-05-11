
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerHeader.dart';

import '../../jid.dart';
import 'AuthMechanism.dart';
import 'UnknownAuthMechanism.dart';
import 'KnownAuthMechanisms.dart';

class Auth {
  final Jid jid;
  final String password;

  Auth(this.jid, this.password);

  AuthMessage createAuthMessage(StreamServerHeader streamServerHeader) {
    var bestMechanism = _pickBestMechanism(streamServerHeader);
    return bestMechanism.buildAuthMessage(this);
  }

  AuthMechanism _pickBestMechanism(StreamServerHeader streamServerHeader) {
    final availableMechanisms = streamServerHeader
        .authMechanisms
        .where((e) => !(e is UnknownAuthMechanism))
        .toList()
        .sortByPreference();

    if (availableMechanisms.isEmpty) {
      return null;
    } else {
      return availableMechanisms.first;
    }
  }
}