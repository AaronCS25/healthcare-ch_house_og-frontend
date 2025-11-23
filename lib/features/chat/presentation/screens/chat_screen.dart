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

  final Map<String, String> _avatarUrls = {
    ChatCubit.kUserId: 'assets/images/rimac_user.jpg',
    ChatCubit.kBotId: 'assets/images/asistente_rimac.png',
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
      ImageProvider? backgroundImage;

      if (image.startsWith('http://') || image.startsWith('https://')) {
        backgroundImage = NetworkImage(image);
      } else {
        backgroundImage = AssetImage(image);
      }

      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[200],
        backgroundImage: backgroundImage,
        onBackgroundImageError: (_, _) => debugPrint('Error cargando avatar'),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[200],
      child: Text(
        (user.name ?? '?').substring(0, 1).toUpperCase(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
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
        listener: (context, state) {
          if (state.messages.isNotEmpty) {
            final lastMessage = state.messages.last;
            if (!_insertedMessageIds.contains(lastMessage.id)) {
              _insertedMessageIds.add(lastMessage.id);
              _chatController.insertMessage(lastMessage);
            }
          }

          if (state.isFailure) {
            SnackBarHelper.showError(context, message: state.errorMessage);
          }
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Stack(
              children: [
                Builder(
                  builder: (context) {
                    final brightness = MediaQuery.platformBrightnessOf(context);
                    final isDark = brightness == Brightness.dark;

                    final baseChatTheme = isDark
                        ? types.ChatTheme.dark()
                        : types.ChatTheme.light();

                    final chatTheme = baseChatTheme.copyWith(
                      colors: baseChatTheme.colors.copyWith(
                        primary: AppTheme.rimacRed,
                        surface: isDark
                            ? const Color(0xFF1f1f1f)
                            : AppTheme.white,
                        onSurface: isDark ? Colors.white : AppTheme.darkGray,
                        surfaceContainer: isDark
                            ? Colors.black
                            : AppTheme.vibrantPink,
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

                                  final bool isBot =
                                      message.authorId == ChatCubit.kBotId;

                                  Widget messageChild = child;
                                  if (message is types.TextMessage) {
                                    final isDarkMode =
                                        Theme.of(context).brightness ==
                                        Brightness.dark;

                                    messageChild = SimpleTextMessage(
                                      message: message,
                                      index: index,

                                      sentBackgroundColor: AppTheme.rimacRed,
                                      sentTextStyle: const TextStyle(
                                        color: Colors.white,
                                        height: 1.4,
                                      ),

                                      receivedBackgroundColor: isBot
                                          ? (isDarkMode
                                                ? Colors.white.withValues(
                                                    alpha: 0.08,
                                                  )
                                                : AppTheme.mediumGray)
                                          : AppTheme.mediumGray,

                                      receivedTextStyle: TextStyle(
                                        color: isDarkMode
                                            ? AppTheme.white
                                            : AppTheme.darkGray,
                                        height: 1.4,
                                      ),
                                    );
                                  }

                                  final String displayName;
                                  if (message.authorId == ChatCubit.kUserId) {
                                    displayName = 'yo';
                                  } else if (message.authorId ==
                                      ChatCubit.kBotId) {
                                    displayName = 'bot';
                                  } else {
                                    displayName = (user.name ?? 'usuario')
                                        .toLowerCase();
                                  }

                                  final Widget nameWidget = Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Align(
                                      alignment: isSentByMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  );

                                  final Widget composedChild = Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: isSentByMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [nameWidget, messageChild],
                                  );

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
                                    child: composedChild,
                                  );
                                },
                              );
                            },
                      ),
                      chatController: _chatController,
                      currentUserId: ChatCubit.kUserId,

                      onMessageSend: (text) {
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

                        context.read<ChatCubit>().sendMessage(text);
                      },
                      resolveUser: _resolveUser,
                    );
                  },
                ),

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
