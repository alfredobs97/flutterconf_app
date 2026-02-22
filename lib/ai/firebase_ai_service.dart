import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutterconf/ai/ai_service.dart';
import 'package:flutterconf/favorites/repository/favorites_repository.dart';
import 'package:flutterconf/schedule/repository/events_repository.dart';
import 'package:flutterconf/schedule/schedule.dart';

class FirebaseAiService implements AiService {
  FirebaseAiService({
    required EventsRepository eventsRepository,
    required FavoritesRepository favoritesRepository,
  }) : _eventsRepository = eventsRepository,
       _favoritesRepository = favoritesRepository {
    _initModel();
  }

  final EventsRepository _eventsRepository;
  final FavoritesRepository _favoritesRepository;

  final List<ChatMessage> _messages = [];
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();

  late final GenerativeModel _model;
  late final ChatSession _chat;

  void _initModel() {
    final getEventsTool = FunctionDeclaration(
      'getEvents',
      'Get the complete schedule of all conference events, talks, and activities.',
      parameters: {
        'dummy': Schema.string(description: 'dummy param'),
      },
    );

    final addFavoriteTool = FunctionDeclaration(
      'addFavorite',
      'Add a specific event or talk to the user\'s favorites list.',
      parameters: {
        'eventName': Schema.string(
          description:
              'The exact name of the event or talk to add to favorites.',
        ),
      },
    );

    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3-flash-preview',
      systemInstruction: Content.system(
        'You are a helpful assistant for the FlutterConf mobile app. You can answer questions about the schedule and add talks to the user\'s favorites. You should use the provided tools to query the schedule and modify favorites. If you use a tool, make sure to let the user know.',
      ),
      tools: [
        Tool.functionDeclarations([getEventsTool, addFavoriteTool]),
      ],
    );
    _chat = _model.startChat();
  }

  @override
  Stream<List<ChatMessage>> get messages async* {
    yield _messages;
    yield* _messagesController.stream;
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    _messagesController.add(List.unmodifiable(_messages));
  }

  @override
  Future<void> sendMessage(String text) async {
    _addMessage(ChatMessage(isUser: true, text: text));

    var response = await _chat.sendMessage(Content.text(text));
    await _handleResponse(response);
  }

  Future<void> _handleResponse(GenerateContentResponse response) async {
    final functionCalls = response.functionCalls.toList();
    if (functionCalls.isNotEmpty) {
      for (final call in functionCalls) {
        if (call.name == 'getEvents') {
          final events = _eventsRepository.getEvents();
          final summary = events.map((Event e) => '- ${e.name}').join('\n');
          final result = {'events': summary};

          final nextResponse = await _chat.sendMessage(
            Content.functionResponse(call.name, result),
          );
          await _handleResponse(nextResponse);
        } else if (call.name == 'addFavorite') {
          final eventName = call.args['eventName'] as String?;
          if (eventName != null) {
            final events = _eventsRepository.getEvents();
            try {
              final matchedEvent = events.firstWhere(
                (Event e) =>
                    e.name.toLowerCase().contains(eventName.toLowerCase()),
              );
              await _favoritesRepository.addFavorite(matchedEvent);
              final result = {
                'success': true,
                'message': 'Added ${matchedEvent.name} to favorites',
              };

              final nextResponse = await _chat.sendMessage(
                Content.functionResponse(call.name, result),
              );
              await _handleResponse(nextResponse);
            } catch (_) {
              final result = {'success': false, 'error': 'Event not found'};
              final nextResponse = await _chat.sendMessage(
                Content.functionResponse(call.name, result),
              );
              await _handleResponse(nextResponse);
            }
          }
        }
      }
    } else if (response.text != null) {
      _addMessage(ChatMessage(isUser: false, text: response.text!));
    }
  }
}
