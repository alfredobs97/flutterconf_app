import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/ai/ai_service.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit({required AiService aiService})
    : _aiService = aiService,
      super(const ChatbotState()) {
    _subscription = _aiService.messages.listen((messages) {
      emit(state.copyWith(messages: messages, status: ChatbotStatus.success));
    });
  }

  final AiService _aiService;
  late final StreamSubscription<List<ChatMessage>> _subscription;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    emit(state.copyWith(status: ChatbotStatus.loading));
    try {
      await _aiService.sendMessage(text);
    } catch (_) {
      emit(state.copyWith(status: ChatbotStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
