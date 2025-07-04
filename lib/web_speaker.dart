import 'dart:js_interop';
import 'package:js/js.dart';

@JS('speakText')
external void _speakText(JSString text);

void speakText(String text) {
  _speakText(text.toJS);
}
