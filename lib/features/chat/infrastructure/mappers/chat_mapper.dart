import 'package:uuid/uuid.dart';
import 'package:rimac_app/features/chat/chat.dart';

class ChatMapper {
  final uuid = const Uuid();

  ChatMessageEntity fromLlmResponse(LlmResponseModel model) {
    return ChatMessageEntity(
      id: uuid.v4(),
      text: model.detail,
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
