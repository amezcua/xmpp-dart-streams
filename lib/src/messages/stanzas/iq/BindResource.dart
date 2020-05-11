import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../../ClientMessage.dart';

class BindResource with ClientMessage {
  @override
  String getXml() {
    final bindId = Uuid().v4();
    final builder = xml.XmlBuilder();
    builder.element('iq',
        attributes: {'type': 'set', 'id': bindId},
        nest: () {
          builder.element('bind', attributes: { 'xmlns': XMPP_BIND });
        });
    return builder.build().toString();
  }
}