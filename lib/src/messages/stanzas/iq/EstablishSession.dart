import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../../ClientMessage.dart';

class EstablishSession with ClientMessage {

  final String _hostName;

  EstablishSession(this._hostName);

  @override
  String getXml() {
    final sessionId = Uuid().v4();
    final builder = xml.XmlBuilder();
    builder.element('iq',
        attributes: {'to': _hostName, 'type': 'set', 'id': sessionId},
        nest: () {
          builder.element('session', attributes: { 'xmlns': XMPP_SESSION });
        });
    return builder.build().toString();
  }
}