import 'package:equatable/equatable.dart';

class StreamId extends Equatable {
  final String sessionId;
  final String host;

  StreamId(this.sessionId, this.host);

  @override
  List<Object> get props => [sessionId, host];

  @override
  String toString() {
    return 'SessionId: $sessionId. Host: $host';
  }
}