import 'package:dio/dio.dart';
import 'package:rimac_app/features/chat/chat.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final Dio dio;

  const ChatDatasourceImpl({required this.dio});

  @override
  Future<ChatMessageEntity> sendMessage(String message) async {
    try {
      final response = await dio.post('/llm/ask', data: {'message': message});
      final llmResponse = LlmResponseModel.fromJson(response.data);
      final chatMessage = ChatMapper().fromLlmResponse(llmResponse);
      return chatMessage;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
