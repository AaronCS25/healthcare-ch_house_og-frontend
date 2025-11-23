import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'No está configurada la API';
  static String llmUrl = dotenv.env['LLM_URL'] ?? 'No está configurada la LLM';
}
