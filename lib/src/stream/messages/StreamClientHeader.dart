
import 'package:xmpp_dart_streams/src/messages/ClientMessage.dart';
import 'package:xmpp_dart_streams/src/messages/Message.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

class StreamClientHeader extends XmppMessage with ClientMessage {
  final String _host;

  StreamClientHeader(this._host);

  @override
  String getXml() {
    return '''
    <?xml version="1.0"?>
    <stream:stream xmlns="$JABBER_CLIENT" xmlns:stream="$STREAM" to="{host}" version="1.0">
    '''.replaceAll('{host}', _host).trim().replaceAll(RegExp('>[\\n\\s]*'), '>');
  }
}