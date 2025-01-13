import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'chess_env.dart' if (dart.library.html) 'package:http/http.dart';

class GeminiMove {
  Future<String> sendToGemini(String prompt) async {
    if (!kIsWeb) {
      final env = EnvVariables();
      final apiKey = env.getGeminiAPI();

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'No adequate response';
    } else {
      return 'No adequate response (Web)';
    }
  }
}
