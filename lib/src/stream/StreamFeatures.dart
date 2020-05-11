
import 'auth/AuthMechanism.dart';

class StreamFeatures {
  final List<AuthMechanism> mechanisms;
  final bool bindRequest;

  StreamFeatures(this.mechanisms, this.bindRequest);
}