import 'package:rimac_app/features/chat/chat.dart';

abstract class ChatRepository {
  Future<ChatMessageEntity> sendMessage(String message);
}
