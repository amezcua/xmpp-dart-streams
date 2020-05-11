import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../../ClientMessage.dart';
import 'SaslChallenge.dart';
import 'ScramAuthRequest.dart';

class SaslChallengeResponse extends ClientMessage {
  final ScramAuthRequest initialAuthRequest;
  final SaslChallenge serverChallenge;
  final String password;

  SaslChallengeResponse(
      this.initialAuthRequest, this.serverChallenge, this.password);

  @override
  String getXml() {
    final authContent = base64Encode(utf8.encode(_buildChallengeResponse(
        initialAuthRequest, serverChallenge, password)));
    final builder = xml.XmlBuilder();
    builder.element('response',
        attributes: {'xmlns': XMPP_SASL}, nest: authContent);
    return builder.build().toString();
  }

  String _buildChallengeResponse(
      ScramAuthRequest clientAuth, SaslChallenge challenge, String password) {
    if (!_nonceValid(clientAuth.nonce, challenge.nonce)) {
      return null;
    } else {
      final hash = clientAuth.mechanism.hash;
      final challengeNonce = challenge.nonce;
      final initialRequest = clientAuth.clientInitialRequest;
      final challengeContent = utf8.decode(base64Decode(challenge.raw));
      final iterations = challenge.iterations;

      final List<int> serverSalt = base64Decode(challenge.saltBase64);
      final finalMessageBare = 'c=biws,r=$challengeNonce';
      final saltedPassword =
          _saltPassword(hash, password, serverSalt, iterations);
      final clientKey = _hmac(hash, saltedPassword, utf8.encode('Client Key'));
      final storedKey = hash.convert(clientKey).bytes;
      final authMessage =
          '$initialRequest,$challengeContent,$finalMessageBare';
      final clientSignature =
          _hmac(hash, storedKey, utf8.encode(authMessage));
      final clientProof = _xor(clientKey, clientSignature);
      final finalMessage = '$finalMessageBare,p=${base64Encode(clientProof)}';

      return finalMessage;
    }
  }

  bool _nonceValid(String clientNonce, String serverNonce) =>
      serverNonce.startsWith(clientNonce);

  List<int> _saltPassword(
      Hash hash, String password, List<int> serverSalt, int iterations) {
    return _pbkdf2(
        hash, utf8.encode(_normalize(password)), serverSalt, iterations);
  }

  String _normalize(String input) => unorm.nfkd(input);

  List<int> _hmac(Hash hash, List<int> key, List<int> input) =>
      Hmac(hash, key).convert(input).bytes;

  List<int> _pbkdf2(
      Hash hash, List<int> password, List<int> salt, int iterations) {
    var u = _hmac(hash, password, salt + [0, 0, 0, 1]);
    var out = List<int>.from(u);
    for (var i = 1; i < iterations; i++) {
      u = _hmac(hash, password, u);
      out = _xor(out, u);
    }
    return out;
  }

  ///
  /// XORs each of the items in the lists
  ///
  List<int> _xor(List<int> l1, List<int> l2) => l1
      .asMap()
      .entries
      .map((MapEntry<int, int> e) => e.value ^ l2[e.key])
      .toList();
}
