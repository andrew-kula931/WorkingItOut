import 'package:google_generative_ai/google_generative_ai.dart';
import 'chess_env.dart';

class GeminiMove {
  final env = EnvVariables();
  Future<String> sendToGemini(String prompt) async {
    final apiKey = env.getGeminiAPI();

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text ?? 'No adequate response';
  }
}
