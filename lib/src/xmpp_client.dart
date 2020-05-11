import 'dart:async';
import 'dart:io';

import 'package:xmpp_dart_streams/src/stream/XmppStream.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerClosed.dart';

import 'disposable.dart';
import 'jid.dart';
import 'messages/ClientMessage.dart';
import 'messages/DebugMessage.dart';
import 'messages/Parsing.dart';
import 'messages/ServerMessage.dart';
import 'messages/Transformers.dart';

class XmppClient implements Disposable {
  final _messagesController = StreamController<ServerMessage>.broadcast();
  Socket _socket;
  List<StreamSubscription> _streamSubscriptions;
  final String _ip;
  int _port;
  bool _connected = false;
  bool _debugEnabled = false;
  Jid _jid = Jid.empty();
  String _password = '';
  
  Jid get jid => _jid;
  String get password => _password;

  XmppClient(this._ip, this._port);

  XmppClient.toServer(this._ip, hostName, userName, this._password) {
    _port = 5222;
    _jid = Jid.simple(userName, hostName);
  }

  XmppClient connect() {
    if (_connected) return this;

    _connect(() {
      if (_streamSubscriptions != null) {
        _streamSubscriptions.forEach((s) {
          s.cancel();
        });
      }
      _streamSubscriptions = XmppStream.init(this);
      _streamSubscriptions.add(streamClosed.listen((event) {
        _connected = false;
        onSocketDone();
        connect(); // Reconnect on stream closed.
      }));
    });

    return this;
  }

  void disconnect() {
    _connected = false;
  }

  Stream<ServerMessage> get messages => _messagesController.stream;

  Stream<DebugMessage> get debugMessages =>
      messages.transform(serverToDebugMessageTransformer);

  Stream<StreamServerClosed> get streamClosed =>
      messages.transform(serverToStreamClosedTransformer);

  XmppClient enableDebug() {
    _debugEnabled = true;
    return this;
  }

  void _connect(Function andThen) {
    Socket.connect(_ip, _port).then((Socket sock) {
      _socket = sock;
      _socket.listen(
        onSocketData,
        onError: onSocketError,
        onDone: onSocketDone,
        cancelOnError: false,
      );
    }).whenComplete(() {
      _connected = true;
      andThen();
    });
  }

  void send(ClientMessage message) {
    if (_connected) {
      _send(message.getXml());
    } else {
      _connect(() => _send(message.getXml()));
    }
  }

  void _send(String message) {
    final trimmedMessage = message.trim().replaceAll(RegExp('>[\\n\\s]*'), '>');
    if (trimmedMessage == '') return;

    if (_debugEnabled) DebugMessage('Sending: ' + trimmedMessage).console();
    _socket.write(trimmedMessage);
  }

  void onSocketData(data) {
    var response = String.fromCharCodes(data).trim();
    parse(response).forEach((serverMessage) {
      _messagesController.sink.add(serverMessage);
    });
    if (_debugEnabled) {
      _messagesController.sink.add(DebugMessage(response).console());
    }
  }

  void onSocketError(error, StackTrace trace) {
    _connected = false;
  }

  void onSocketDone() {
    _socket.destroy();
    _connected = false;
  }

  @override
  void dispose() {
    _messagesController.close();
    onSocketDone();
  }
}
