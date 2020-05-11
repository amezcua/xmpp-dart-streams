import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../../../ClientMessage.dart';


class RequestRoster extends ClientMessage {
  @override
  String getXml() {
    final builder = xml.XmlBuilder();
    builder.element('iq',
        attributes: {'type': 'get'},
        nest: () {
          builder.element('query', attributes: { 'xmlns': JABBER_ROSTER });
        });
    return builder.build().toString();
  }
}