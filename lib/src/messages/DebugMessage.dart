
import 'ClientMessage.dart';
import 'Message.dart';
import 'ServerMessage.dart';

class DebugMessage extends XmppMessage with ClientMessage, ServerMessage {
  final String _text;

  DebugMessage(this._text);

  @override
  String getXml() {
    return _text;
  }

  DebugMessage console() {
    print(DateTime.now().toString() + ': ' + _text);
    return this;
  }
}
