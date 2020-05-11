import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/stream/auth/ScramAuthMechanism.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../AuthMessage.dart';

class ScramAuthRequest extends AuthMessage {
  final String nonce = base64Encode(utf8.encode(Uuid().v4()));
  final String userName;
  final ScramAuthMechanism mechanism;

  String get clientInitialRequest => 'n=$userName,r=$nonce';

  ScramAuthRequest(this.userName, this.mechanism);

  @override
  String getXml() {
    final builder = xml.XmlBuilder();
    builder.element('auth',
        attributes: {'xmlns': XMPP_SASL, 'mechanism': mechanism.name},
        nest: _base64Auth(clientInitialRequest));
    return builder.build().toString();
  }

  String _base64Auth(String clientInitialRequest) {
    final g2ClientInitialRequest = utf8.encode('n,,$clientInitialRequest');
    final authBytes = <int>[];
    authBytes.addAll(g2ClientInitialRequest);
    return base64.encode(authBytes);
  }
}