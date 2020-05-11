import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';
import 'dart:convert';

import '../../Parsing.dart';
import '../../ServerMessage.dart';

class SaslChallenge extends ServerMessage {
  final String nonce;
  final String saltBase64;
  final int iterations;
  final String raw;

  SaslChallenge(this.nonce, this.saltBase64, this.iterations, this.raw);

  static final ServerMessageParser parse = (String rawMessage) {
    try {
      final parsed = xml.parse(rawMessage);

      if (_isSaslChallenge(parsed)) {
        return _inspectSaslChallenge(parsed);
      } else {
        return null;
      }
    } on XmlParserException {
      return null;
    }
  };

  static bool _isSaslChallenge(xml.XmlDocument xmlChallenge) {
    var rootElement = xmlChallenge.rootElement;
    return rootElement.name.local == 'challenge' &&
        rootElement.attributes.length == 1 &&
        rootElement.attributes.first.name.local == 'xmlns' &&
        rootElement.attributes.first.value == XMPP_SASL;
  }

  static SaslChallenge _inspectSaslChallenge(xml.XmlDocument xmlChallenge) {
    var rootElement = xmlChallenge.rootElement;
    final raw = rootElement.text;
    final challenge = utf8.decode(base64.decode(raw));
    final challengeParts = challenge.split(',');
    if (challengeParts.length != 3) return null; // Invalid challenge

    final challengeNonce = challengeParts[0].substring(2);
    final serverSalt = challengeParts[1].substring(2);
    final iterations = int.tryParse(challengeParts[2].substring(2));

    if (challengeNonce == null || serverSalt == null || iterations == null) {
      return null;
    }
    return SaslChallenge(challengeNonce, serverSalt, iterations, raw);
  }
}
