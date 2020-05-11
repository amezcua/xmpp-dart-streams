import 'dart:async';

import 'package:xmpp_dart_streams/src/stream/messages/ResourceBound.dart';
import 'package:xmpp_dart_streams/src/stream/messages/SessionInitiated.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerClosed.dart';
import 'package:xmpp_dart_streams/src/stream/messages/StreamServerHeader.dart';

import 'DebugMessage.dart';
import 'ServerMessage.dart';
import 'auth/AuthResultMessage.dart';
import 'auth/scram/SaslChallenge.dart';

// The transformers allow us to provide different streams with typed
// messages to listen to. That way we can subscribe only to the relevant
// messages that we want easily.
StreamTransformer<ServerMessage, DebugMessage>
    get serverToDebugMessageTransformer =>
        StreamTransformer<ServerMessage, DebugMessage>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is DebugMessage) sink.add(m);
        });

StreamTransformer<ServerMessage, StreamServerHeader>
    get serverToAuthStreamServerHeaderTransformer =>
        StreamTransformer<ServerMessage, StreamServerHeader>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is StreamServerHeader && m.authMechanisms.isNotEmpty) {
            sink.add(m);
          }
        });

StreamTransformer<ServerMessage, AuthResultMessage>
    get serverToAuthResultTransformer =>
        StreamTransformer<ServerMessage, AuthResultMessage>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is AuthResultMessage) sink.add(m);
        });

StreamTransformer<ServerMessage, StreamServerHeader>
    get serverToBindRequestStreamServerHeaderTransformer =>
        StreamTransformer<ServerMessage, StreamServerHeader>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is StreamServerHeader && m.isBindRequest) sink.add(m);
        });

StreamTransformer<ServerMessage, ResourceBound>
    get serverToResourceBoundTransformer =>
        StreamTransformer<ServerMessage, ResourceBound>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is ResourceBound) sink.add(m);
        });

StreamTransformer<ServerMessage, SessionInitiated>
    get serverToSessionInitiatedTransformer =>
        StreamTransformer<ServerMessage, SessionInitiated>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is SessionInitiated) sink.add(m);
        });

StreamTransformer<ServerMessage, StreamServerClosed>
    get serverToStreamClosedTransformer =>
        StreamTransformer<ServerMessage, StreamServerClosed>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is StreamServerClosed) sink.add(m);
        });

StreamTransformer<ServerMessage, SaslChallenge>
    get serverToSaslChallengeTransformer =>
        StreamTransformer<ServerMessage, SaslChallenge>.fromHandlers(
            handleData: (ServerMessage m, EventSink sink) {
          if (m is SaslChallenge) sink.add(m);
        });
