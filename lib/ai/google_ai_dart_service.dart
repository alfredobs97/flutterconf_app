import 'package:flutterconf/ai/ai_service.dart';

class GoogleAiDartService implements AiService {
  final List<ChatMessage> _messages = [];

  @override
  Stream<List<ChatMessage>> get messages async* {
    yield _messages;
  }

  @override
  Future<void> sendMessage(String text) async {
    _messages.add(ChatMessage(isUser: true, text: text));
    // TODO: Implement actual googleai_dart call and function handling.

    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock response
    _messages.add(
      const ChatMessage(isUser: false, text: "I am a mock Google AI response."),
    );
  }
}
