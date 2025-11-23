import 'package:dio/dio.dart';
import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/chat/chat.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.llmUrl));

  @override
  Future<ChatMessageEntity> sendMessage(String message) async {
    try {
      final response = await dio.post(
        '/agent/route',
        data: {'user_id': 'pochoni', 'message': message},
      );
      final llmResponse = LlmResponseModel.fromJson(response.data);
      final chatMessage = ChatMapper().fromLlmResponse(llmResponse);
      return chatMessage;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
