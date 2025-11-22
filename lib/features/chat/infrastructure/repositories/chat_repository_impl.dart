import 'package:rimac_app/features/chat/chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  const ChatRepositoryImpl(this.datasource);

  @override
  Future<ChatMessage> sendMessage(String message) {
    return datasource.sendMessage(message);
  }
}
