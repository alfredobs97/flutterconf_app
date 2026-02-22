import 'dart:async';
import 'dart:convert';

import 'package:flutterconf/schedule/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A repository that manages favorite events.
class FavoritesRepository {
  FavoritesRepository({required SharedPreferences prefs}) : _prefs = prefs {
    _init();
  }

  final SharedPreferences _prefs;
  final _favoritesController = StreamController<List<Event>>.broadcast();
  List<Event> _currentFavorites = [];

  static const _favoritesKey = 'favorites_v2';

  void _init() {
    final favoritesString = _prefs.getString(_favoritesKey);
    if (favoritesString != null) {
      try {
        final decoded = jsonDecode(favoritesString) as List;
        _currentFavorites = decoded
            .map((e) => Event.fromJson(e as Map<String, dynamic>))
            .where((e) => allEvents.contains(e))
            .toList();
      } catch (_) {
        _currentFavorites = [];
      }
    }
    _favoritesController.add(_currentFavorites);
  }

  /// A stream of the user's favorite events.
  Stream<List<Event>> get favorites => _favoritesController.stream;

  /// Returns the current list of favorite events.
  List<Event> get currentFavorites => List.unmodifiable(_currentFavorites);

  /// Adds an event to the favorites list.
  Future<void> addFavorite(Event event) async {
    if (!_currentFavorites.contains(event)) {
      _currentFavorites = [..._currentFavorites, event]
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      await _save();
    }
  }

  /// Removes an event from the favorites list.
  Future<void> removeFavorite(Event event) async {
    if (_currentFavorites.contains(event)) {
      _currentFavorites = List.from(_currentFavorites)..remove(event);
      await _save();
    }
  }

  Future<void> _save() async {
    _favoritesController.add(_currentFavorites);
    final encoded = jsonEncode(_currentFavorites.map(Event.toJson).toList());
    await _prefs.setString(_favoritesKey, encoded);
  }
}
