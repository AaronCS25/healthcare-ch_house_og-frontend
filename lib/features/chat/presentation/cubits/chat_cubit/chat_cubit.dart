import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as types;

import 'package:rimac_app/features/chat/chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final _uuid = const Uuid();

  static const String kUserId = 'user';
  static const String kBotId = 'bot';

  ChatCubit({required this.repository}) : super(const ChatState());

  Future<void> sendMessage(String text) async {
    if (state.isLoading) return;

    final userMessage = types.Message.text(
      id: _uuid.v4(),
      authorId: kUserId,
      text: text,
      createdAt: DateTime.now(),
    );

    // Build new list snapshot including the user's message so subsequent
    // emits are based on the same collection (avoids race conditions).
    final messagesWithUser = [...state.messages, userMessage];

    emit(
      state.copyWith(
        messages: messagesWithUser,
        status: ChatStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      final domainMessage = await repository.sendMessage(text);
      final botMessage = _mapDomainToUi(domainMessage);

      final messagesWithBot = [...messagesWithUser, botMessage];

      if (isClosed) return;

      emit(
        state.copyWith(messages: messagesWithBot, status: ChatStatus.success),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: ChatStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  types.TextMessage _mapDomainToUi(ChatMessageEntity domainMsg) {
    return types.TextMessage(
      id: domainMsg.id,
      text: domainMsg.text,
      createdAt: domainMsg.createdAt,
      authorId: domainMsg.isUser ? kUserId : kBotId,
    );
  }
}
