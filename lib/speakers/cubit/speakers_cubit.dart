import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/speakers/speakers.dart';

class SpeakersCubit extends Cubit<SpeakersState> {
  SpeakersCubit() : super(const SpeakersState());

  void loadSpeakers() {
    emit(state.copyWith(speakers: speakers));
  }

  void onSearchChanged(String query) {
    emit(state.copyWith(query: query));
  }

  void onSortOrderChanged(SpeakerSortOrder sortOrder) {
    emit(state.copyWith(sortOrder: sortOrder));
  }
}
