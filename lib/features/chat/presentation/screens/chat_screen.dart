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

  @override
  void initState() {
    super.initState();
    _chatController = types.InMemoryChatController();
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
                        textMessageBuilder:
                            (
                              BuildContext ctx,
                              dynamic message,
                              int index, {
                              required bool isSentByMe,
                              dynamic groupStatus,
                            }) {
                              return SimpleTextMessage(
                                message: message,
                                index: index,
                                sentBackgroundColor: AppTheme.rimacRed,
                                receivedBackgroundColor: AppTheme.mediumGray,
                                sentTextStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                receivedTextStyle: const TextStyle(
                                  color: AppTheme.darkGray,
                                ),
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

                      resolveUser: (types.UserID id) async {
                        // Definir usuarios
                        if (id == ChatCubit.kUserId) {
                          return types.User(id: id, name: 'Tú');
                        } else {
                          return types.User(id: id, name: 'Asistente RIMAC');
                        }
                      },
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
