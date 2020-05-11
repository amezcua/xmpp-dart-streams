/// The server may send in a single response a number of independent
/// messages. Each of them is a valid XML doc but the complete response is not.
/// We need to be able to deconstruct such response and extract the individual
/// parts for further parsing.

import 'package:test/test.dart';
import 'package:xmpp_dart_streams/src/messages/Parsing.dart';

void main() {

  final part1 = "<presence from='alice@localhost' to='bob@localhost' type='subscribe'><status></status></presence>";
  final part2 = "<presence from='bob@localhost/E03A6CC654D4E6571587-753171-59630' to='bob@localhost/E03A6CC654D4E6571587-753171-59630'/>";
  final part3 = "<iq from='bob@localhost' to='bob@localhost/E03A6CC654D4E6571587-753171-59630' id='' type='result'><query xmlns='jabber:iq:roster'><item subscription='to' jid='alice@localhost'/></query></iq>";
  final response = part1 + part2 + part3;

  test('Combined response is correctly broken into parts', () {
    final parsedParts = parse(response);

    expect(parsedParts.length, equals(3));
  });
}