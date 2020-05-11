import 'package:uuid/uuid.dart';
import 'package:xmpp_dart_streams/src/messages/ClientMessage.dart';
import 'package:xmpp_dart_streams/src/messages/Message.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

class InitClientStream extends XmppMessage with ClientMessage {
  final String _hostName;

  InitClientStream(this._hostName);

  @override
  String getXml() {
    final streamId = Uuid().v4();

    return "<stream:stream xmlns='$JABBER_CLIENT' xmlns:stream='$STREAM' id='$streamId' to='$_hostName' version='1.0'>";
  }
}
