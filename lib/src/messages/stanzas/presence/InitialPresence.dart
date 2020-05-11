import 'package:xml/xml.dart' as xml;

import '../../ClientMessage.dart';

class InitialPresence extends ClientMessage {
  @override
  String getXml() {
    final builder = xml.XmlBuilder();
    builder.element('presence');
    return builder.build().toString();
  }
}