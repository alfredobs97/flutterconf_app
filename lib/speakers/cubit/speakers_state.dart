import 'package:equatable/equatable.dart';
import 'package:flutterconf/speakers/speakers.dart';

enum SpeakerSortOrder { nameAsc, nameDesc }

class SpeakersState extends Equatable {
  const SpeakersState({
    this.speakers = const [],
    this.query = '',
    this.sortOrder = SpeakerSortOrder.nameAsc,
  });

  final List<Speaker> speakers;
  final String query;
  final SpeakerSortOrder sortOrder;

  List<Speaker> get filteredSpeakers {
    final filtered = speakers.where((speaker) {
      final nameMatches = speaker.name.toLowerCase().contains(
        query.toLowerCase(),
      );
      final titleMatches = speaker.title.toLowerCase().contains(
        query.toLowerCase(),
      );
      return nameMatches || titleMatches;
    }).toList();

    if (sortOrder == SpeakerSortOrder.nameAsc) {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else {
      filtered.sort((a, b) => b.name.compareTo(a.name));
    }

    return filtered;
  }

  SpeakersState copyWith({
    List<Speaker>? speakers,
    String? query,
    SpeakerSortOrder? sortOrder,
  }) {
    return SpeakersState(
      speakers: speakers ?? this.speakers,
      query: query ?? this.query,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [speakers, query, sortOrder];
}
