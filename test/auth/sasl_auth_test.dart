import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:xmpp_dart_streams/src/messages/auth/scram/SaslChallenge.dart';

void main() {
  test('SASL challenge is decoded correctly', () {
    final challengeContent = 'cj1iODYxZmI2My02N2YwLTRiZDItOTZlYi1lOTVjOTVlZjRlY2FBVTQ1V2J2MlVNdmR3SHNQTEdheWJBPT0scz1oVmtRYzZLc1prSGF1T21GT1o1RDVnPT0saT00MDk2';
    final challenge = "<challenge xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>$challengeContent</challenge>";
    final challengeNonce = 'b861fb63-67f0-4bd2-96eb-e95c95ef4ecaAU45Wbv2UMvdwHsPLGaybA==';
    final serverSaltBase64 = 'hVkQc6KsZkHauOmFOZ5D5g==';
    final iterations = 4096;

    final SaslChallenge decoded = SaslChallenge.parse(challenge);

    expect(decoded, isNotNull);
    expect(decoded.iterations, equals(iterations));
    expect(decoded.nonce, equals(challengeNonce));
    expect(decoded.saltBase64, equals(serverSaltBase64));
    expect(decoded.raw, equals(challengeContent));
  });

  test('Scram SHA1 items', () {
    final Hash hashFunction = sha1;
    final userName = 'user';
    final password = 'pencil';
    final clientNonce = 'fyko+d2lbbFgONRv9qkxdawL';
    final clientInitialRequest = 'n=$userName,r=$clientNonce';
    final serverNonce = '${clientNonce}3rfcNHYJY1ZVvWVs7j';
    final iterations = 4096;
    final serverSalt = 'QSXCR+Q6sek8bf92';
    final serverChallenge = 'r=$serverNonce,s=$serverSalt,i=$iterations';

    final List<int> calculatedServerSalt = base64Decode(serverSalt);
    final expectedServerSaltHex = '4125c247e43ab1e93c6dff76';

    expect(HexEncoder().convert(calculatedServerSalt), equals(expectedServerSaltHex));

    final clientFinalMessageBare = 'c=biws,r=$serverNonce';
    final clientSaltedPassword = createSaltedPassword(hashFunction, password, calculatedServerSalt, iterations);
    final expectedClientSaltedPasswordHex = '1d96ee3a529b5a5f9e47c01f229a2cb8a6e15f7d';

    expect(HexEncoder().convert(clientSaltedPassword), equals(expectedClientSaltedPasswordHex));

    final clientKey = hmac(hashFunction, clientSaltedPassword, utf8.encode('Client Key'));
    final storedKey = hashFunction.convert(clientKey).bytes;
    final expectedClientKeyHex = 'e234c47bf6c36696dd6d852b99aaa2ba26555728';
    final expectedStoredKeyHex = 'e9d94660c39d65c38fbad91c358f14da0eef2bd6';

    expect(HexEncoder().convert(clientKey), equals(expectedClientKeyHex));
    expect(HexEncoder().convert(storedKey), equals(expectedStoredKeyHex));

    final authMessage = '$clientInitialRequest,$serverChallenge,$clientFinalMessageBare';
    final clientSignature = hmac(hashFunction, storedKey, utf8.encode(authMessage));
    final expectedClientSignatureHex = '5d7138c486b0bfabdf49e3e2da8bd6e5c79db613';

    expect(HexEncoder().convert(clientSignature), equals(expectedClientSignatureHex));

    final clientProof = xor(clientKey, clientSignature);
    final expectedClientProofHex = 'bf45fcbf7073d93d022466c94321745fe1c8e13b';

    expect(HexEncoder().convert(clientProof), expectedClientProofHex);

    final serverKey = hmac(hashFunction, clientSaltedPassword, utf8.encode('Server Key'));
    final expectedServerKeyHex = '0fe09258b3ac852ba502cc62ba903eaacdbf7d31';

    expect(HexEncoder().convert(serverKey), equals(expectedServerKeyHex));

    final serverSignature = hmac(hashFunction, serverKey, utf8.encode(authMessage));
    final expectedServerSignatureHex = 'ae617da6a57c4bbb2e0286568dae1d251905b0a4';

    expect(HexEncoder().convert(serverSignature), equals(expectedServerSignatureHex));

    final clientFinalMessage = '$clientFinalMessageBare,p=${base64Encode(clientProof)}';
    final clientFinalMessageExpected = 'c=biws,r=fyko+d2lbbFgONRv9qkxdawL3rfcNHYJY1ZVvWVs7j,p=v0X8v3Bz2T0CJGbJQyF0X+HI4Ts=';

    expect(clientFinalMessage, equals(clientFinalMessageExpected));
  });

  test('SCRAM Sha256 items', () {
    ///
    /// This is a simple example of a SCRAM-SHA-256 authentication exchange
    //   'user' and password 'pencil' are being used.
    //
    //   C: n,,n=user,r=rOprNGfwEbeRWgbNEkqO
    //
    //   S: r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,
    //      s=W22ZaJ0SNY7soEsUEjb6gQ==,i=4096
    //
    //   C: c=biws,r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,
    //      p=dHzbZapWIk4jUhN+Ute9ytag9zjfMHgsqmmiz7AndVQ=
    //
    //   S: v=6rriTRBi23WpRR/wtup+mMhUZUn/dB5nLTJRsjl95G4=

    final Hash hashFunction = sha256;
    final userName = 'user';
    final password = 'pencil';

    final clientNonce = 'rOprNGfwEbeRWgbNEkqO';
    final clientInitialRequest = 'n=$userName,r=$clientNonce';
    final serverNonce = '%hvYDpWUa2RaTCAfuxFIlj)hNlF\$k0';
    final serverSaltBase64 = 'W22ZaJ0SNY7soEsUEjb6gQ==';
    final iterations = 4096;
    final serverChallenge = 'r=$clientNonce$serverNonce,s=$serverSaltBase64,i=$iterations';
    final List<int> serverSalt = base64Decode(serverSaltBase64);

    final clientFinalMessageBare = 'c=biws,r=$clientNonce$serverNonce';
    final clientSaltedPassword = createSaltedPassword(hashFunction, password, serverSalt, iterations);
    final clientKey = hmac(hashFunction, clientSaltedPassword, utf8.encode('Client Key'));
    final storedKey = hashFunction.convert(clientKey).bytes;
    final authMessage = '$clientInitialRequest,$serverChallenge,$clientFinalMessageBare';
    final clientSignature = hmac(hashFunction, storedKey, utf8.encode(authMessage));
    final clientProof = xor(clientKey, clientSignature);
    final clientFinalMessage = '$clientFinalMessageBare,p=${base64Encode(clientProof)}';

    final expectedClientFinalMessage = 'c=biws,r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF\$k0,p=dHzbZapWIk4jUhN+Ute9ytag9zjfMHgsqmmiz7AndVQ=';

    expect(clientFinalMessage, equals(expectedClientFinalMessage));
  });

  test('Sasl challenge parsing', () {
    final iterations = 4096;
    final clientNonce = 'rOprNGfwEbeRWgbNEkqO';
    final serverNonce = '$clientNonce%hvYDpWUa2RaTCAfuxFIlj)hNlF\$k0';
    final serverSaltBase64 = 'W22ZaJ0SNY7soEsUEjb6gQ==';
    final serverChallenge = 'r=$serverNonce,s=$serverSaltBase64,i=$iterations';
    final challenge = "<challenge xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>${base64Encode(utf8.encode(serverChallenge))}</challenge>";

    final SaslChallenge parsed = SaslChallenge.parse(challenge);

    expect(parsed.nonce, equals('$serverNonce'));
    expect(parsed.iterations, equals(iterations));
    expect(parsed.saltBase64, equals(serverSaltBase64));
  });
}

List<int> createSaltedPassword(Hash hash, String password, List<int> serverSalt, int iterations) {
  return pbkdf2(hash, utf8.encode(normalize(password)), serverSalt, iterations);
}

String saslEscape(String input) => 
    input.replaceAll('=', '=2C').replaceAll(',', '=3D');

String normalize(String input) => unorm.nfkd(input);

List<int> hmac(Hash hash, List<int> key, List<int> input) =>
    Hmac(hash, key).convert(input).bytes;

List<int> pbkdf2(Hash hash, List<int> password, List<int> salt, int iterations) {
  var u = hmac(hash, password, salt + [0,0,0,1]);
  var out = List<int>.from(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac(hash, password, u);
    out = xor(out, u);
  }
  return out;
}

///
/// XORs each of the items in the lists
/// 
List<int> xor(List<int> l1, List<int> l2) => 
    l1.asMap()
        .entries
        .map((MapEntry<int, int> e) => e.value ^ l2[e.key])
        .toList();