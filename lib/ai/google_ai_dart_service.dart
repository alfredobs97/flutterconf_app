// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'dart:async';

import 'package:flutterconf/ai/ai_service.dart';
import 'package:flutterconf/favorites/repository/favorites_repository.dart';
import 'package:flutterconf/location/data/venues.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';
import 'package:flutterconf/schedule/repository/events_repository.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleAiDartService implements AiService {
  GoogleAiDartService({
    required EventsRepository eventsRepository,
    required FavoritesRepository favoritesRepository,
    required ScannedProfilesRepository scannedProfilesRepository,
    required String apiKey,
  })  : _eventsRepository = eventsRepository,
        _favoritesRepository = favoritesRepository,
        _scannedProfilesRepository = scannedProfilesRepository,
        _client = GoogleAIClient(
          config: GoogleAIConfig.googleAI(
            authProvider: ApiKeyProvider(apiKey),
          ),
        ) {
    _initModel();
  }

  final EventsRepository _eventsRepository;
  final FavoritesRepository _favoritesRepository;
  final ScannedProfilesRepository _scannedProfilesRepository;
  final GoogleAIClient _client;

  final List<ChatMessage> _messages = [];
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();

  final List<Content> _history = [];
  late final List<Tool> _tools;
  late final Content _systemInstruction;

  void _initModel() {
    const getEventsTool = FunctionDeclaration(
      name: 'getEvents',
      description:
          'Get the complete schedule of all conference events, talks, and activities.',
      parameters: Schema(
        type: SchemaType.object,
      ),
    );

    const addFavoriteTool = FunctionDeclaration(
      name: 'addFavorite',
      description: "Add a specific event or talk to the user's favorites list.",
      parameters: Schema(
        type: SchemaType.object,
        properties: {
          'eventName': Schema(
            type: SchemaType.string,
            description:
                'The exact name of the event or talk to add to favorites.',
          ),
        },
      ),
    );

    const getVenuesTool = FunctionDeclaration(
      name: 'getVenues',
      description:
          'Get information about the conference venues and their locations.',
      parameters: Schema(
        type: SchemaType.object,
      ),
    );

    const launchMapTool = FunctionDeclaration(
      name: 'launchMap',
      description: 'Open a map navigation link for a specific venue.',
      parameters: Schema(
        type: SchemaType.object,
        properties: {
          'url': Schema(
            type: SchemaType.string,
            description: 'The map URL to open.',
          ),
        },
      ),
    );

    const getScannedProfilesTool = FunctionDeclaration(
      name: 'getScannedProfiles',
      description:
          'Get a list of all profiles (people) the user has scanned during the conference.',
      parameters: Schema(
        type: SchemaType.object,
      ),
    );

    _tools = [
      const Tool(
        functionDeclarations: [
          getEventsTool,
          addFavoriteTool,
          getVenuesTool,
          launchMapTool,
          getScannedProfilesTool,
        ],
      ),
    ];

    _systemInstruction = Content.text(
      "You are a helpful assistant for the FlutterConf mobile app. You can answer questions about the schedule, event locations, add talks to the user's favorites, and summarize people the user has scanned. You should use the provided tools to query the schedule, get venue information, open maps, modify favorites, and list scanned profiles. If you use a tool, make sure to let the user know.",
    );
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
    _history.add(Content.user([TextPart(text)]));

    final request = GenerateContentRequest(
      contents: _history,
      tools: _tools,
      systemInstruction: _systemInstruction,
    );

    final response = await _client.models.generateContent(
      model: 'gemini-3-flash-preview',
      request: request,
    );

    await _handleResponse(response);
  }

  Future<void> _handleResponse(GenerateContentResponse response) async {
    final functionCalls = response.functionCalls;

    if (functionCalls.isEmpty) {
      if (response.text != null) {
        _history.add(Content.model([TextPart(response.text!)]));
        _addMessage(ChatMessage(isUser: false, text: response.text!));
      }
      return;
    }

    _history.add(Content.model(response.candidates!.first.content!.parts));

    final functionResponseParts = <Part>[];

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
        functionResponseParts.add(Part.functionResponse(call.name, result));
      }
    }

    _history.add(Content(role: 'user', parts: functionResponseParts));

    final nextResponse = await _client.models.generateContent(
      model: 'gemini-3-flash-preview',
      request: GenerateContentRequest(
        contents: _history,
        tools: _tools,
        systemInstruction: _systemInstruction,
      ),
    );
    await _handleResponse(nextResponse);
  }

  Map<String, Object> _handleGetEvents() {
    final events = _eventsRepository.getEvents();
    final summary = events.map((Event e) => '- ${e.name}').join('\n');
    return {'events': summary};
  }

  Future<Map<String, Object>> _handleAddFavorite(FunctionCall call) async {
    final eventName = call.args?['eventName'] as String?;
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
    } on Exception catch (_) {
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
    final url = call.args?['url'] as String?;
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
