import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();

Future<void> speakText(String text) async {
  await flutterTts.setLanguage("en-US"); 
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.45);
  await flutterTts.setVolume(1.0);

  await flutterTts.speak(text);
}
