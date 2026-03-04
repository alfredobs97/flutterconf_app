import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/ai/google_ai_dart_service.dart';
import 'package:flutterconf/chatbot/cubit/chatbot_cubit.dart';
import 'package:flutterconf/chatbot/widgets/widgets.dart';
import 'package:flutterconf/favorites/repository/favorites_repository.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/schedule/repository/events_repository.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatbotCubit(
        aiService: GoogleAiDartService(
          eventsRepository: context.read<EventsRepository>(),
          favoritesRepository: context.read<FavoritesRepository>(),
          scannedProfilesRepository: context.read<ScannedProfilesRepository>(),
          apiKey: const String.fromEnvironment('GOOGLE_AI_API_KEY'),
        ),
      ),
      child: const ChatbotView(),
    );
  }
}

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatbotCubit>().sendMessage(text);
      _controller.clear();
      _focusNode.requestFocus();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) {
                _scrollToBottom();
                if (state.status == ChatbotStatus.failure &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: theme.colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.messages.isEmpty &&
                    state.status != ChatbotStatus.loading &&
                    state.status != ChatbotStatus.failure) {
                  return WelcomeView(
                    onSuggestionTapped: (text) {
                      _controller.text = text;
                      _sendMessage();
                    },
                  );
                }

                final itemCount = state.messages.length +
                    (state.status == ChatbotStatus.loading ? 1 : 0) +
                    (state.status == ChatbotStatus.failure &&
                            state.errorMessage != null
                        ? 1
                        : 0);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == state.messages.length) {
                      if (state.status == ChatbotStatus.loading) {
                        return const ThinkingBubble();
                      }
                      if (state.status == ChatbotStatus.failure &&
                          state.errorMessage != null) {
                        return ErrorBubble(message: state.errorMessage!);
                      }
                    }
                    final message = state.messages[index];
                    final isLast = index == state.messages.length - 1;
                    return MessageBubble(message: message, isLast: isLast);
                  },
                );
              },
            ),
          ),
          BlocBuilder<ChatbotCubit, ChatbotState>(
            buildWhen: (prev, curr) => prev.status != curr.status,
            builder: (context, state) {
              return ChatInput(
                controller: _controller,
                focusNode: _focusNode,
                onSend: _sendMessage,
                isLoading: state.status == ChatbotStatus.loading,
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6],
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Asistente Gemini'),
        ],
      ),
      centerTitle: true,
    );
  }
}
