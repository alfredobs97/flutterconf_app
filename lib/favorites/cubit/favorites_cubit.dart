import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/favorites/repository/favorites_repository.dart';
import 'package:flutterconf/schedule/schedule.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required FavoritesRepository repository})
    : _repository = repository,
      super(FavoritesState(events: repository.currentFavorites)) {
    _subscription = _repository.favorites.listen((events) {
      emit(state.copyWith(events: events));
    });
  }

  final FavoritesRepository _repository;
  late final StreamSubscription<List<Event>> _subscription;

  Future<void> toggleFavorite(Event event) async {
    if (state.events.contains(event)) {
      await _repository.removeFavorite(event);
    } else {
      await _repository.addFavorite(event);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
