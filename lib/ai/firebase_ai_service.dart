// ignore_for_file: lines_longer_than_80_chars, document_ignores, avoid_catches_without_on_clauses

import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutterconf/ai/ai_service.dart';
import 'package:flutterconf/favorites/repository/favorites_repository.dart';
import 'package:flutterconf/location/data/venues.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';
import 'package:flutterconf/schedule/repository/events_repository.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FirebaseAiService implements AiService {
  FirebaseAiService({
    required EventsRepository eventsRepository,
    required FavoritesRepository favoritesRepository,
    required ScannedProfilesRepository scannedProfilesRepository,
  })  : _eventsRepository = eventsRepository,
        _favoritesRepository = favoritesRepository,
        _scannedProfilesRepository = scannedProfilesRepository {
    _initModel();
  }

  final EventsRepository _eventsRepository;
  final FavoritesRepository _favoritesRepository;
  final ScannedProfilesRepository _scannedProfilesRepository;

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
      "Add a specific event or talk to the user's favorites list.",
      parameters: {
        'eventName': Schema.string(
          description:
              'The exact name of the event or talk to add to favorites.',
        ),
      },
    );

    final getVenuesTool = FunctionDeclaration(
      'getVenues',
      'Get information about the conference venues and their locations.',
      parameters: {
        'dummy': Schema.string(description: 'dummy param'),
      },
    );

    final launchMapTool = FunctionDeclaration(
      'launchMap',
      'Open a map navigation link for a specific venue.',
      parameters: {
        'url': Schema.string(
          description: 'The map URL to open.',
        ),
      },
    );

    final getScannedProfilesTool = FunctionDeclaration(
      'getScannedProfiles',
      'Get a list of all profiles (people) the user has scanned during the conference.',
      parameters: {
        'dummy': Schema.string(description: 'dummy param'),
      },
    );

    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3-flash-preview',
      systemInstruction: Content.system(
        "You are a helpful assistant for the FlutterConf mobile app. You can answer questions about the schedule, event locations, add talks to the user's favorites, and summarize people the user has scanned. You should use the provided tools to query the schedule, get venue information, open maps, modify favorites, and list scanned profiles. If you use a tool, make sure to let the user know.",
      ),
      tools: [
        Tool.functionDeclarations([
          getEventsTool,
          addFavoriteTool,
          getVenuesTool,
          launchMapTool,
          getScannedProfilesTool,
        ]),
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
    final response = await _chat.sendMessage(Content.text(text));
    await _handleResponse(response);
  }

  Future<void> _handleResponse(GenerateContentResponse response) async {
    final functionCalls = response.functionCalls.toList();

    if (functionCalls.isEmpty) {
      return _addMessage(ChatMessage(isUser: false, text: response.text!));
    }

    for (final call in functionCalls) {
      final result = switch (call.name) {
        'getEvents' => _handleGetEvents(),
        'addFavorite' => await _handleAddFavorite(call),
        'getVenues' => _handleGetVenues(),
        'launchMap' => await _handleLaunchMap(call),
        'getScannedProfiles' => await _handleGetScannedProfiles(),
        _ => null,
      };

      if (result != null) {
        final nextResponse = await _chat.sendMessage(
          Content.functionResponse(call.name, result),
        );
        await _handleResponse(nextResponse);
      }
    }
  }

  Map<String, Object> _handleGetEvents() {
    final events = _eventsRepository.getEvents();
    final summary = events.map((Event e) => '- ${e.name}').join('\n');
    return {'events': summary};
  }

  Future<Map<String, Object>> _handleAddFavorite(FunctionCall call) async {
    final eventName = call.args['eventName'] as String?;
    if (eventName == null) {
      return {'success': false, 'error': 'eventName is missing'};
    }

    final events = _eventsRepository.getEvents();
    try {
      final matchedEvent = events.firstWhere(
        (Event e) => e.name.toLowerCase().contains(eventName.toLowerCase()),
      );
      await _favoritesRepository.addFavorite(matchedEvent);
      return {
        'success': true,
        'message': 'Added ${matchedEvent.name} to favorites'
      };
    } catch (_) {
      return {'success': false, 'error': 'Event not found'};
    }
  }

  Map<String, Object> _handleGetVenues() {
    const venues = [gsecMalaga, innovationCampus];
    final summary =
        venues.map((Location l) => '- ${l.name} (${l.mapUrl})').join('\n');
    return {'venues': summary};
  }

  Future<Map<String, Object>> _handleLaunchMap(FunctionCall call) async {
    final url = call.args['url'] as String?;
    if (url == null) {
      return {'success': false, 'error': 'url is missing'};
    }

    final success = await launchUrlString(url);
    return {
      'success': success,
      'message': success ? 'Map opened' : 'Could not open map',
    };
  }

  Future<Map<String, Object>> _handleGetScannedProfiles() async {
    final profiles = await _scannedProfilesRepository.getScannedProfiles();
    final summary = profiles.isEmpty
        ? 'No profiles scanned yet.'
        : profiles
            .map((ScannedProfile p) =>
                '- ${p.displayName} (scanned on ${p.scannedAt})')
            .join('\n');
    return {'profiles': summary};
  }
}
