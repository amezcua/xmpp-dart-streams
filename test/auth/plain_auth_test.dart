import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/messages/auth/PlainAuthMessage.dart';
import 'dart:convert';

import 'package:xmpp_dart_streams/src/stream/auth/PlainAuthMechanism.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';


void main() {
  test('Plain auth generates correct XML', () {
    final userName = 'aUserName';
    final password = 'aPassword';
    final hostName = 'localhost';
    final userNameBytes = utf8.encode('$userName@$hostName');
    final passwordBytes = utf8.encode(password);
    final authBytes = <int>[];
    authBytes.addAll(utf8.encode('\u0000'));
    authBytes.addAll(userNameBytes);
    authBytes.addAll(utf8.encode('\u0000'));
    authBytes.addAll(passwordBytes);
    final base64AuthString = base64.encode(authBytes);

    var plainAuth = PlainAuthMechanism();
    var plainAuthMessage = PlainAuthMessage(userName, password, hostName, plainAuth);
    final authXml = plainAuthMessage.getXml();
    final expected = '<auth xmlns="$XMPP_SASL" mechanism="PLAIN">$base64AuthString</auth>';

    expect(authXml, equals(expected));
  });
}