import 'package:equatable/equatable.dart';

import '../../../../jid.dart';

class RosterItem extends Equatable {
  final Jid jid;

  RosterItem(this.jid);

  @override
  List<Object> get props => [jid];
}