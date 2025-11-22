class ChatMessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });
}
