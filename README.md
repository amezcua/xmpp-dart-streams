XMPP Dart streams. A client Dart library for the XMPP protocol.

## Usage

A simple usage example:

```dart
import 'package:xmpp_dart_streams/xmpp_dart_streams.dart';

main() {
  var xmppClient = XmppClient.toServer(
                  "[ip address]", "[xmpp host]", "[user name]", "[user password]")
              .enableDebug()
              .connect();
  
  var chatMessage = ChatMessage("A message", Jid.simple("alice", "localhost")); // Send to alice@localhost
  xmppClient.send(chatMessage);
  
  xmppClient.messages.listen((m) {
    // Handle message m          
  });
}
```

## Features and bugs

Supports scram-sha256, scram-sha1 and plain authentication in that order.

The user's roster can be retrieved but only the Jids are returned.

The library is under development. Testing and PRs welcome.