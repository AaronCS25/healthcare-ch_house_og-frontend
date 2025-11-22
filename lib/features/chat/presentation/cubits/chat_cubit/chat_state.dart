part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final List<types.Message> messages;
  final ChatStatus status;
  final String errorMessage;

  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage = '',
  });

  bool get isLoading => status == ChatStatus.loading;
  bool get isSuccess => status == ChatStatus.success;
  bool get isFailure => status == ChatStatus.failure;

  @override
  List<Object> get props => [messages, status, errorMessage];

  ChatState copyWith({
    List<types.Message>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
