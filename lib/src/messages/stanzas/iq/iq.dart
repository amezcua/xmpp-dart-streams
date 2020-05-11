import 'package:xml/xml.dart' as xml;

bool isIqResult(xml.XmlDocument parsed) {
  var isIq = parsed.rootElement.name.local == 'iq';
  var isResult = parsed.rootElement.attributes
      .any((attr) => attr.name.local == 'type' && attr.value == 'result');

  return isIq && isResult;
}