import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as types;
import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/chat/chat.dart';
import 'package:rimac_app/features/shared/shared.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(repository: ServiceLocator.get<ChatRepository>()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final types.InMemoryChatController _chatController;
  final Set<String> _insertedMessageIds = {};

  // Map of avatar images for known users (fallback to initials if absent)
  final Map<String, String> _avatarUrls = {
    ChatCubit.kUserId:
        'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg',
    ChatCubit.kBotId:
        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
  };

  Future<types.User> _resolveUser(types.UserID id) async {
    if (id == ChatCubit.kUserId) {
      return types.User(id: id, name: 'Tú');
    } else if (id == ChatCubit.kBotId) {
      return types.User(id: id, name: 'Asistente RIMAC');
    }

    return types.User(id: id, name: 'Usuario');
  }

  Widget _buildAvatar(types.User user) {
    final image = (_avatarUrls[user.id] ?? '').trim();
    if (image.isNotEmpty) {
      return CircleAvatar(radius: 20, backgroundImage: NetworkImage(image));
    }

    return CircleAvatar(
      radius: 20,
      child: Text(
        (user.name ?? '?').substring(0, 1).toUpperCase(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _chatController = types.InMemoryChatController();
    _chatController.insertMessage(
      const types.Message.text(
        id: 'first-ai',
        authorId: ChatCubit.kBotId,
        text: "¡Hola! Soy el asistente de RIMAC. ¿En qué puedo ayudarte hoy?",
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: BlocListener<ChatCubit, ChatState>(
        // Escuchar cambios del Cubit y sincronizar con el controller
        listener: (context, state) {
          // Insert the last message when new messages arrive. We handle
          // both loading (the user's message) and success (bot reply) and
          // guard against inserting duplicates by tracking IDs.
          if (state.messages.isNotEmpty) {
            final lastMessage = state.messages.last;
            if (!_insertedMessageIds.contains(lastMessage.id)) {
              _insertedMessageIds.add(lastMessage.id);
              _chatController.insertMessage(lastMessage);
            }
          }

          // Show errors
          if (state.isFailure) {
            SnackBarHelper.showError(context, message: state.errorMessage);
          }
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Derive a chat theme from the app theme and override brand colors
                Builder(
                  builder: (context) {
                    final brightness = MediaQuery.platformBrightnessOf(context);
                    final baseChatTheme = brightness == Brightness.dark
                        ? types.ChatTheme.dark()
                        : types.ChatTheme.light();

                    final chatTheme = baseChatTheme.copyWith(
                      colors: baseChatTheme.colors.copyWith(
                        primary: AppTheme.rimacRed,
                        surfaceContainer: AppTheme.vibrantPink,
                        surface: AppTheme.white,
                        onSurface: AppTheme.darkGray,
                      ),
                    );

                    return Chat(
                      theme: chatTheme,
                      builders: types.Builders(
                        chatMessageBuilder:
                            (
                              BuildContext ctx,
                              dynamic message,
                              int index,
                              animation,
                              child, {
                              bool? isRemoved,
                              required bool isSentByMe,
                              types.MessageGroupStatus? groupStatus,
                            }) {
                              return FutureBuilder<types.User>(
                                future: _resolveUser(message.authorId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return ChatMessage(
                                      message: message,
                                      index: index,
                                      animation: animation,
                                      isRemoved: isRemoved,
                                      groupStatus: groupStatus,
                                      child: child,
                                    );
                                  }

                                  final user = snapshot.data!;

                                  // Determine a custom child for text messages so
                                  // we can control bubble colors per author.
                                  final bool isBot =
                                      message.authorId == ChatCubit.kBotId;

                                  Widget messageChild = child;
                                  if (message is types.TextMessage) {
                                    messageChild = SimpleTextMessage(
                                      message: message,
                                      index: index,
                                      // User (sent) keeps rimacRed
                                      sentBackgroundColor: AppTheme.rimacRed,
                                      // Bot messages get a more visible vibrant pink
                                      receivedBackgroundColor: isBot
                                          ? AppTheme.vibrantPink
                                          : AppTheme.mediumGray,
                                      sentTextStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      receivedTextStyle: TextStyle(
                                        color: isBot
                                            ? Colors.white
                                            : AppTheme.darkGray,
                                      ),
                                    );
                                  }

                                  return ChatMessage(
                                    message: message,
                                    index: index,
                                    animation: animation,
                                    isRemoved: isRemoved,
                                    groupStatus: groupStatus,
                                    leadingWidget: !isSentByMe
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: _buildAvatar(user),
                                          )
                                        : null,
                                    trailingWidget: isSentByMe
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: _buildAvatar(user),
                                          )
                                        : null,
                                    child: messageChild,
                                  );
                                },
                              );
                            },
                      ),
                      chatController: _chatController,
                      currentUserId: ChatCubit.kUserId,

                      onMessageSend: (text) {
                        // Prevent sending while waiting for a response
                        if (state.isLoading) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Espera la respuesta antes de enviar otro mensaje',
                              ),
                            ),
                          );
                          return;
                        }

                        // Delegar al Cubit
                        context.read<ChatCubit>().sendMessage(text);
                      },
                      resolveUser: _resolveUser,
                    );
                  },
                ),

                // Loading bar at top while waiting for bot response
                if (state.isLoading)
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 72,
                    left: 16,
                    right: 16,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Asistente RIMAC está escribiendo',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 36,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
