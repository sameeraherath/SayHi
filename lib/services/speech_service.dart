import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static String _spokenText = "";

  static Future<void> initSpeech() async {
    await _speech.initialize();
  }

  static void startListening() {
    _speech.listen(
      onResult: (result) {
        _spokenText = result.recognizedWords;
        print("User said: $_spokenText");
      },
    );
  }

  static Future<String> stopListening() async {
    await _speech.stop();
    print("Final result: $_spokenText");
    return _spokenText;
  }
}
