import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart' as xml;

import '../../../jid.dart';
import '../../ClientMessage.dart';
import 'MessageTypes.dart';

abstract class Message extends ClientMessage {
  final MessageType messageType;
  final String body;
  final Jid to;

  Message(this.messageType, this.body, this.to);

  @override
  String getXml() {
    final messageId = Uuid().v4();
    final builder = xml.XmlBuilder();
    builder.element('message',
        attributes: {
          'type': messageType.getValue(),
          'id': messageId,
          'to': to.toString()
        },
        nest: () {
          builder.element('body', nest: body);
        });
    return builder.build().toString();
  }
}