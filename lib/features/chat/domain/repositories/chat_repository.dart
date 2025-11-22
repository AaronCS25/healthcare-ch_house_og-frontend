import 'package:rimac_app/features/chat/chat.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String message);
}
