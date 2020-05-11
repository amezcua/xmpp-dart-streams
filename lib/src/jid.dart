import 'package:equatable/equatable.dart';

class Jid extends Equatable {
  final String userId;
  final String host;
  final String resourceId;

  Jid(this.userId, this.host, this.resourceId);

  Jid.simple(userId, host): this(userId, host, '');

  Jid.empty(): this('', '', '');

  Jid.from(String from): this(from.parse().userId, from.parse().host, from.parse().resourceId);

  @override
  List<Object> get props => [userId, host, resourceId];

  @override
  String toString() {
    if (resourceId.isEmpty) {
      return '$userId@$host';
    } else {
      return '$userId@$host/$resourceId';
    }
  }
}

extension JidExt on String {
  Jid parse() {
    try {
      final userHostParts = split('@');
      final userId = userHostParts[0];
      final hostResource = userHostParts[1];
      var host = hostResource;
      var resourceId = '';
      if (hostResource.contains('/')) {
        final hostResourceParts = hostResource.split('/');
        host = hostResourceParts[0];
        resourceId = hostResourceParts[1];
      }

      return Jid(userId, host, resourceId);
    } catch (e) {
      throw ArgumentError("Can not parse '$this' as a Jid.");
    }
  }
}