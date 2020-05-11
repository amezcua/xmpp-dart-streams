import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

import '../Message.dart';
import '../Parsing.dart';
import 'AuthResultMessage.dart';

class AuthSuccess extends AuthResultMessage with XmppMessage {
  static final ServerMessageParser parse = (String rawMessage) {
    try {
      final parsed = xml.parse(rawMessage);

      if (parsed.rootElement.name.toString() == 'success') {
        return AuthSuccess();
      } else {
        return null;
      }
    } on XmlParserException {
      return null;
    }
  };
}