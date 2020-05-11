import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/stream/auth/PlainAuthMechanism.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';
import 'dart:convert';

import 'AuthMessage.dart';

class PlainAuthMessage extends AuthMessage {
  final String userName;
  final String password;
  final String hostName;
  final PlainAuthMechanism mechanism;

  PlainAuthMessage(this.userName, this.password, this.hostName, this.mechanism);

  @override
  String getXml() {
    final builder = xml.XmlBuilder();
    builder.element('auth',
        attributes: {'xmlns': XMPP_SASL, 'mechanism': mechanism.name},
        nest: _base64Auth(userName, password));
    return builder.build().toString();
  }

  String _base64Auth(String userName, String password) {
    final userNameBytes = utf8.encode('$userName@$hostName');
    final passwordBytes = utf8.encode(password);
    final authBytes = <int>[];
    authBytes.addAll(utf8.encode('\u0000'));
    authBytes.addAll(userNameBytes);
    authBytes.addAll(utf8.encode('\u0000'));
    authBytes.addAll(passwordBytes);
    return base64.encode(authBytes);
  }
}
