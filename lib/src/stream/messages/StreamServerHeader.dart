import 'package:tuple/tuple.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/messages/Message.dart';
import 'package:xmpp_dart_streams/src/messages/Parsing.dart';
import 'package:xmpp_dart_streams/src/messages/ServerMessage.dart';
import 'package:xmpp_dart_streams/src/stream/auth/AuthMechanism.dart';
import 'package:xmpp_dart_streams/src/stream/auth/KnownAuthMechanisms.dart';
import 'package:xmpp_dart_streams/src/xml/namespaces.dart';

import '../StreamFeatures.dart';
import '../StreamId.dart';

class StreamServerHeader extends ServerMessage with XmppMessage {
  static const _hostIdCapture =
      r"<?xml version='1.0'\?><stream:stream xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' id='(.+?)' from='(.+?)'";
  static const _featuresHeaderCapture =
      r"(<\?xml version='1.0'\?>.+?(?=<stream:features>))";

  StreamId streamId;
  List<AuthMechanism> authMechanisms;
  bool isBindRequest;

  static final ServerMessageParser parse = (String rawMessage) {
    try {
      final headerParts = _extractHeaderParts(rawMessage);
      final serverHeader = StreamServerHeader();
      serverHeader.streamId = headerParts.item1;
      serverHeader.authMechanisms = headerParts.item2.mechanisms;
      serverHeader.isBindRequest = headerParts.item2.bindRequest;
      return serverHeader;
    } catch (e) {
      return null;
    }
  };

  static Tuple2<StreamId, StreamFeatures> _extractHeaderParts(
      String rawMessage) {
    final trimmedMessage = rawMessage.trim();

    final streamId = _extractStreamId(trimmedMessage);
    final featuresXml = _extractFeaturesXml(trimmedMessage);
    final authMechanisms = _extractAuthMechanisms(featuresXml);
    final bindRequest = _isBindRequest(featuresXml);

    return Tuple2<StreamId, StreamFeatures>(
        streamId, StreamFeatures(authMechanisms, bindRequest));
  }

  static StreamId _extractStreamId(String message) {
    var matches =
        RegExp(_hostIdCapture, caseSensitive: false).allMatches(message);

    final id = matches.first.group(1).toString();
    final host = matches.first.group(2).toString();

    return StreamId(id, host);
  }

  static List<AuthMechanism> _extractAuthMechanisms(xml.XmlDocument features) {
    return features
        .findAllElements('mechanism')
        .map((e) => findAuthMechanismByName(e.text))
        .toList();
  }

  static bool _isBindRequest(xml.XmlDocument features) {
    return features
        .findAllElements('bind', namespace: XMPP_BIND)
        .toList()
        .isNotEmpty;
  }

  static xml.XmlDocument _extractFeaturesXml(String message) {
    final featuresHeaderCapture =
        RegExp(_featuresHeaderCapture, caseSensitive: false);

    final headerUpToFeatures =
        featuresHeaderCapture.allMatches(message).first.group(1).toString();
    return xml.parse(message.substring(headerUpToFeatures.length));
  }

  @override
  String toString() {
    final type = super.toString();
    return '$type. StreamId: $streamId';
  }
}
