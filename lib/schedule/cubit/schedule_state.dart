part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  const ScheduleState({
    required this.index,
    this.searchQuery = '',
  });

  static const day1 = ScheduleState(index: 0);
  static const day2 = ScheduleState(index: 1);

  final int index;
  final String searchQuery;

  List<Event> get filteredDay1 => _filter(day1Events);
  List<Event> get filteredDay2 => _filter(day2Events);

  List<Event> _filter(List<Event> events) {
    if (searchQuery.isEmpty) return events;
    final query = searchQuery.toLowerCase();
    return events.where((event) {
      final nameMatches = event.name.toLowerCase().contains(query);
      if (nameMatches) return true;

      if (event is Talk) {
        return event.speakers.any(
          (speaker) =>
              speaker.name.toLowerCase().contains(query) ||
              speaker.title.toLowerCase().contains(query),
        );
      }
      if (event is Workshop) {
        return event.speakers.any(
          (speaker) =>
              speaker.name.toLowerCase().contains(query) ||
              speaker.title.toLowerCase().contains(query),
        );
      }
      return false;
    }).toList();
  }

  @override
  List<Object> get props => [index, searchQuery];

  ScheduleState copyWith({
    int? index,
    String? searchQuery,
  }) {
    return ScheduleState(
      index: index ?? this.index,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
