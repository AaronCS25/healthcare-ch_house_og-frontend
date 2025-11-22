import 'package:rimac_app/features/chat/chat.dart';

abstract class ChatDatasource {
  Future<ChatMessage> sendMessage(String message);
}
