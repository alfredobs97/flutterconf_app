part of 'chatbot_cubit.dart';

enum ChatbotStatus { initial, loading, success, failure }

class ChatbotState extends Equatable {
  const ChatbotState({
    this.status = ChatbotStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  final ChatbotStatus status;
  final List<ChatMessage> messages;
  final String? errorMessage;

  ChatbotState copyWith({
    ChatbotStatus? status,
    List<ChatMessage>? messages,
    String? errorMessage,
  }) {
    return ChatbotState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
