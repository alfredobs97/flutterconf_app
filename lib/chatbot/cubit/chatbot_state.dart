part of 'chatbot_cubit.dart';

enum ChatbotStatus { initial, loading, success, failure }

class ChatbotState extends Equatable {
  const ChatbotState({
    this.status = ChatbotStatus.initial,
    this.messages = const [],
  });

  final ChatbotStatus status;
  final List<ChatMessage> messages;

  ChatbotState copyWith({
    ChatbotStatus? status,
    List<ChatMessage>? messages,
  }) {
    return ChatbotState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [status, messages];
}
