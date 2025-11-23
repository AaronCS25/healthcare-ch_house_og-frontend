import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as types;
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
  final TextEditingController _textController = TextEditingController();
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top; // Altura del notch

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                Container(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? null
                          : RadialGradient(
                              center: const Alignment(1.0, -0.2),
                              radius: 1.2,
                              colors: [
                                AppTheme.rimacRed.withValues(alpha: 0.9),
                                AppTheme.rimacRed.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                    ),
                    child: Stack(
                      children: [
                        Builder(
                          builder: (context) {
                            final brightness = MediaQuery.platformBrightnessOf(
                              context,
                            );
                            final isDark = brightness == Brightness.dark;

                            final backgroundColor = isDark
                                ? const Color(0xFF121212)
                                : Colors.transparent;

                            final baseChatTheme = isDark
                                ? types.ChatTheme.dark()
                                : types.ChatTheme.light();

                            final chatTheme = baseChatTheme.copyWith(
                              colors: baseChatTheme.colors.copyWith(
                                primary: AppTheme.rimacRed,
                                surface: backgroundColor,
                                onSurface: isDark
                                    ? Colors.white
                                    : AppTheme.darkGray,
                                surfaceContainer: isDark
                                    ? Colors.black
                                    : AppTheme.vibrantPink,
                              ),
                            );

                            return Chat(
                              theme: chatTheme,
                              builders: types.Builders(
                                chatAnimatedListBuilder:
                                    (context, itemBuilder) {
                                      return types.ChatAnimatedList(
                                        itemBuilder: itemBuilder,
                                        topPadding: 20,
                                      );
                                    },
                                composerBuilder: (context) {
                                  return Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).padding.bottom +
                                            16,
                                        top: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? const Color(0xFF2C2C2C)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                border: Border.all(
                                                  color: isDark
                                                      ? Colors.transparent
                                                      : Colors.grey.shade300,
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                          alpha: 0.05,
                                                        ),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: TextField(
                                                controller:
                                                    _textController, // ⬅️ Usa el controller
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Escribe un mensaje...',
                                                  hintStyle: TextStyle(
                                                    color: isDark
                                                        ? Colors.white54
                                                        : Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                  isDense: true,
                                                ),
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                onSubmitted: (_) {
                                                  final text = _textController
                                                      .text
                                                      .trim();
                                                  if (text.isNotEmpty &&
                                                      !state.isLoading) {
                                                    context
                                                        .read<ChatCubit>()
                                                        .sendMessage(text);
                                                    _textController.clear();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                              color: AppTheme.rimacRed,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.rimacRed
                                                      .withValues(alpha: 0.4),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.send_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () {
                                                      final text =
                                                          _textController.text
                                                              .trim();
                                                      if (text.isNotEmpty) {
                                                        context
                                                            .read<ChatCubit>()
                                                            .sendMessage(text);
                                                        _textController.clear();
                                                      }
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                                            return const SizedBox();
                                          }

                                          final user = snapshot.data!;
                                          final bool isBot =
                                              message.authorId ==
                                              ChatCubit.kBotId;
                                          final isDark =
                                              Theme.of(context).brightness ==
                                              Brightness.dark;

                                          Widget messageChild = child;

                                          if (message is types.TextMessage) {
                                            if (isBot) {
                                              messageChild = ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        20,
                                                      ),
                                                      topRight: Radius.circular(
                                                        20,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(4),
                                                    ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 10,
                                                    sigmaY: 10,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? const Color(
                                                              0xFF2C2C2C,
                                                            ).withValues(
                                                              alpha: 0.6,
                                                            )
                                                          : Colors.white
                                                                .withValues(
                                                                  alpha: 0.65,
                                                                ),
                                                      border: Border.all(
                                                        color: isDark
                                                            ? Colors.white
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  )
                                                            : Colors.white
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          message.text,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            height: 1.4,
                                                            color: isDark
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF1F2937,
                                                                  ),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              messageChild = Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.rimacRed,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppTheme.rimacRed
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  message.text,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              );
                                            }
                                          }

                                          final String displayName =
                                              (message.authorId ==
                                                  ChatCubit.kUserId)
                                              ? 'yo'
                                              : (message.authorId ==
                                                        ChatCubit.kBotId
                                                    ? 'Asistente RIMAC'
                                                    : 'usuario');

                                          final Widget? nameWidget = isBot
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 4.0,
                                                        left: 4.0,
                                                      ),
                                                  child: Text(
                                                    displayName,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                )
                                              : null;

                                          final Widget composedChild = Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: isSentByMe
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: [
                                              if (nameWidget != null)
                                                nameWidget,
                                              messageChild,
                                            ],
                                          );
                                          return ChatMessage(
                                            message: message,
                                            index: index,
                                            animation: animation,
                                            isRemoved: isRemoved,
                                            groupStatus: groupStatus,
                                            leadingWidget: !isSentByMe
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 8.0,
                                                        ),
                                                    child: _buildAvatar(user),
                                                  )
                                                : null,
                                            trailingWidget: isSentByMe
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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

                              onMessageSend: (text) {},
                              resolveUser: _resolveUser,
                            );
                          },
                        ),

                        if (state.isLoading)
                          Positioned(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 72,
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
                    ),
                  ),
                ),

                // ✨ CAPA BLUR SOBRE EL NOTCH ✨
                if (topPadding > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: ClipRect(
                        child: SizedBox(
                          height: topPadding,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    isDark
                                        ? Colors.black.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.5),
                                    isDark
                                        ? Colors.black.withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
