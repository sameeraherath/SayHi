import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static final String _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";
  static const String _url = "https://openrouter.ai/api/v1/chat/completions";
  static const String _model = "mistralai/mistral-7b-instruct";

  static Future<String> sendMessage(String message) async {
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://sayhi.ai', // optional
      'X-Title': 'SayHi',
    };

    final body = jsonEncode({
      "model": _model,
      "messages": [
        {
          "role": "system",
          "content":
              "You are a friendly English tutor. Respond casually to help the user practice English speaking.",
        },
        {"role": "user", "content": message},
      ],
    });

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        return reply.trim();
      } else {
        return "Sorry, I couldn't understand. Please try again.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
