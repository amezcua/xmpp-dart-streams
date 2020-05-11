import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:xmpp_dart_streams/src/messages/Transformers.dart';
import 'package:xmpp_dart_streams/src/messages/auth/AuthMessage.dart';
import 'package:xmpp_dart_streams/src/messages/auth/AuthSuccess.dart';
import 'package:xmpp_dart_streams/src/messages/auth/scram/SaslChallenge.dart';
import 'package:xmpp_dart_streams/src/messages/auth/scram/SaslChallengeResponse.dart';
import 'package:xmpp_dart_streams/src/messages/auth/scram/ScramAuthRequest.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/BindResource.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/EstablishSession.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/iq/roster/RequestRoster.dart';
import 'package:xmpp_dart_streams/src/messages/stanzas/presence/InitialPresence.dart';

import '../../xmpp_dart_streams.dart';
import 'auth/Auth.dart';
import 'messages/StreamClientHeader.dart';
import 'messages/StreamServerHeader.dart';
import 'messages/init_client_stream.dart';

class XmppStream {
  static final BehaviorSubject<ScramAuthRequest> _authRequests =
      BehaviorSubject();
  static final BehaviorSubject<SaslChallenge> _saslChallenges =
      BehaviorSubject();

  static List<StreamSubscription> init(XmppClient xmppClient) {
    final subscriptions = <StreamSubscription>[];

    final serverAuthHeader = xmppClient.messages
        .transform(serverToAuthStreamServerHeaderTransformer)
        .listen((m) {
      var authMessage = _authenticate(xmppClient, m);
      if (authMessage is ScramAuthRequest) {
        _authRequests.add(authMessage);
      }
      return authMessage;
    });

    final userAuthenticateResults = xmppClient.messages
        .transform(serverToAuthResultTransformer)
        .listen((m) {
      if (m is AuthSuccess) {
        _initClientStream(xmppClient);
      }
    });

    final bindRequest = xmppClient.messages
        .transform(serverToBindRequestStreamServerHeaderTransformer)
        .listen((m) => _bindResource(xmppClient));

    final resourceBound = xmppClient.messages
        .transform(serverToResourceBoundTransformer)
        .listen((m) => _establishSession(xmppClient));

    final sessionInitiated = xmppClient.messages
        .transform(serverToSessionInitiatedTransformer)
        .listen((m) {
      _sendInitialPresence(xmppClient);
      _requestRoster(xmppClient);
    });

    final saslChallenges = xmppClient.messages
        .transform(serverToSaslChallengeTransformer)
        .listen((m) => _saslChallenges.add(m));

    final saslRequestChallenges = _saslChallenges
        .withLatestFrom(_authRequests,
            (SaslChallenge response, request) => Tuple2(request, response))
        .listen((m) => _respondToSaslChallenge(m, xmppClient));

    xmppClient.send(StreamClientHeader(xmppClient.jid.host));
    subscriptions
      ..add(serverAuthHeader)
      ..add(saslChallenges)
      ..add(saslRequestChallenges)
      ..add(userAuthenticateResults)
      ..add(bindRequest)
      ..add(resourceBound)
      ..add(sessionInitiated);

    return subscriptions;
  }

  static AuthMessage _authenticate(
      XmppClient xmppClient, StreamServerHeader message) {
    final authMessage =
        Auth(xmppClient.jid, xmppClient.password).createAuthMessage(message);
    xmppClient.send(authMessage);
    return authMessage;
  }

  static void _initClientStream(XmppClient xmppClient) =>
      xmppClient.send(InitClientStream(xmppClient.jid.host));

  static void _bindResource(XmppClient xmppClient) =>
      xmppClient.send(BindResource());

  static void _establishSession(XmppClient xmppClient) =>
      xmppClient.send(EstablishSession(xmppClient.jid.host));

  static void _sendInitialPresence(XmppClient xmppClient) =>
      xmppClient.send(InitialPresence());

  static void _requestRoster(XmppClient xmppClient) =>
      xmppClient.send(RequestRoster());

  static void _respondToSaslChallenge(
      Tuple2 challengeData, XmppClient xmppClient) {
    ScramAuthRequest request = challengeData.item1;
    SaslChallenge response = challengeData.item2;

    xmppClient
        .send(SaslChallengeResponse(request, response, xmppClient.password));
  }
}
