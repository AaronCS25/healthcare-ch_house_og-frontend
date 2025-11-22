import 'package:uuid/uuid.dart';
import 'package:rimac_app/features/chat/chat.dart';

class ChatMapper {
  final uuid = const Uuid();

  ChatMessage fromLlmResponse(LlmResponseModel model) {
    return ChatMessage(
      id: uuid.v4(),
      text: model.detail,
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
