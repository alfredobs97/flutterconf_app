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
      if (_isProcessing) {
        emit(state.copyWith(messages: messages));
      } else {
        emit(state.copyWith(messages: messages, status: ChatbotStatus.success));
      }
    });
  }

  final AiService _aiService;
  late final StreamSubscription<List<ChatMessage>> _subscription;
  bool _isProcessing = false;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    _isProcessing = true;
    emit(state.copyWith(status: ChatbotStatus.loading));
    try {
      await _aiService.sendMessage(text);
      _isProcessing = false;
      emit(state.copyWith(status: ChatbotStatus.success));
    } on Exception catch (e) {
      _isProcessing = false;

      emit(state.copyWith(
        status: ChatbotStatus.failure,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  String _getErrorMessage(Exception e) {
    return switch (e) {
      _
          when e.toString().contains('SocketException') ||
              e.toString().contains('Network') =>
        'Error de conexión. Por favor, revisa tu internet.',
      _ when e.toString().contains('429') || e.toString().contains('quota') =>
        'Se ha alcanzado el límite de mensajes. Prueba más tarde.',
      _
          when e.toString().contains('401') ||
              e.toString().contains('API key') ||
              e.toString().contains('AuthenticationException') =>
        'Error de configuración (API Key).',
      _ => 'Lo siento, ha ocurrido un error inesperado.',
    };
  }
}
