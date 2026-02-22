/// Represents a message in the chat interface.
class ChatMessage {
  const ChatMessage({
    required this.isUser,
    required this.text,
  });

  final bool isUser;
  final String text;
}

/// Abstract service defining the AI Chatbot capabilities.
abstract class AiService {
  /// A stream of the chat history.
  Stream<List<ChatMessage>> get messages;

  /// Sends a message from the user to the AI agent.
  ///
  /// The service will add the user message, process it (including any
  /// function calls like adding favorites), and then append the AI's response.
  Future<void> sendMessage(String text);
}
