import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListening = false;
  String lastWords = "";

  @override
  void initState() {
    super.initState();
    print("Initializing Speech...");
    SpeechService.initSpeech();
  }

  void _handleMicTap() async {
    if (isListening) {
      String text = await SpeechService.stopListening();
      setState(() => isListening = false);
      if (text.isNotEmpty) {
        String aiReply = await AIService.sendMessage(text);
        await TTSService.speak(aiReply);
      }
    } else {
      setState(() => isListening = true);
      print("Starting mic...");
      SpeechService.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _handleMicTap,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: isListening ? Colors.red : Colors.deepPurple,
            child: Icon(
              isListening ? Icons.stop : Icons.mic,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
