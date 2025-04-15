import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey =
      "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";
  static const String _url = "https://openrouter.ai/api/v1/chat/completions";
  static const String _model = "mistralai/mistral-7b-instruct";

  static Future<String> sendMessage(String message) async {
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://your-app-name.com', // optional
      'X-Title': 'SayHi', // optional title
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
