
import 'dart:math';

import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/stream/auth/PlainAuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/ScramSHA1AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/ScramSHA256AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamClientHeader.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerHeader.dart';

void main() {
  var clientStreamStartTemplate = '''<?xml version="1.0"?>
  <stream:stream xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams" to="{host}" version="1.0">
  '''.trim().replaceAll(RegExp('>[\\n\\s]*'), '>');

  test('Client stream start is converted to XML', () {
    var hostName = Random().nextInt(10000).toString();
    var streamStart = StreamClientHeader(hostName);
    
    var xml = streamStart.getXml();

    expect(xml, equals(clientStreamStartTemplate.replaceAll('{host}', hostName)));
  });

  test('Server stream start is parsed correctly', () {
    var id = '12D6D68D8B3FCB47';
    var host = 'localhost';
    var rawHeader = '''
    <?xml version='1.0'?><stream:stream xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' id='$id' from='$host' version='1.0' xml:lang='en'><stream:features><starttls xmlns='urn:ietf:params:xml:ns:xmpp-tls'/><mechanisms xmlns='urn:ietf:params:xml:ns:xmpp-sasl'><mechanism>PLAIN</mechanism><mechanism>DIGEST-MD5</mechanism><mechanism>SCRAM-SHA-1</mechanism><mechanism>SCRAM-SHA-256</mechanism></mechanisms><register xmlns='http://jabber.org/features/iq-register'/><sm xmlns='urn:xmpp:sm:3'/></stream:features>
    ''';

    StreamServerHeader serverHeader = StreamServerHeader.parse(rawHeader);

    expect(serverHeader.streamId.sessionId, equals(id));
    expect(serverHeader.streamId.host, equals(host));
    expect(serverHeader.authMechanisms, contains(PlainAuthMechanism()));
    expect(serverHeader.authMechanisms, contains(ScramSHA1AuthMechanism()));
    expect(serverHeader.authMechanisms, contains(ScramSHA256AuthMechanism()));
  });
}
