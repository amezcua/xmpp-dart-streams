import 'package:xml/xml.dart' as xml;
import 'package:xmpp_dart_streams/src/messages/stanzas/presence/PresenceSubscriptionRequest.dart';
import 'package:xmpp_dart_streams/src/stream/messages/ResourceBound.dart';
import 'package:xmpp_dart_streams/src/stream/messages/SessionInitiated.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerClosed.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerHeader.dart';

import 'DebugMessage.dart';
import 'ServerMessage.dart';
import 'auth/AuthSuccess.dart';
import 'auth/scram/SaslChallenge.dart';

typedef ServerMessageParser = ServerMessage Function(String m);

// Parsers are checked in order, so it is relevant.
final _parsers = <ServerMessageParser>[]
  ..add(StreamServerHeader.parse)
  ..add(StreamServerClosed.parse)
  ..add(SaslChallenge.parse)
  ..add(AuthSuccess.parse)
  ..add(ResourceBound.parse)
  ..add(SessionInitiated.parse)
  ..add(PresenceSubscriptionRequest.parse);

List<ServerMessage> parse(String response) => deconstruct(response)
    .map((singleMessage) => _parse(singleMessage))
    .toList();

ServerMessage _parse(String message) {
  for (final p in _parsers) {
    try {
      var parsed = p(message);
      if (parsed != null) {
        return parsed;
      }
    } catch (e) {
      return DebugMessage('Can not parse message: $message due to error $e')
          .console();
    }
  }
  return DebugMessage('Can not understand unknown message: $message')
      .console();
}

// Extract the list of messages from the response as a single response may
// contain multiple XML messages (not necessarily well formed)
List<String> deconstruct(String response) {
  try {
    xml.parse(response);
    return <String>[]..add(response); // Single valid XML
  } catch (e) {
    // Not valid xml if header continue
    if (StreamServerHeader.parse(response) != null) {
      return <String>[]..add(response);
    } else {
      // Wrap in XML fake and try again
      final wrapped = '<wrapped>$response</wrapped>';
      try {
        final parsed = xml.parse(wrapped);
        return parsed.root.children.first.children.map((c) => c.toString()).toList();
      } catch(e) {
        return <String>[]..add(response);
      }
    }
  }
}
