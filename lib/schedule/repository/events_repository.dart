import 'package:flutterconf/schedule/schedule.dart';

/// A repository that provides access to the conference events.
class EventsRepository {
  /// Returns a listing of all events in the conference.
  List<Event> getEvents() {
    return allEvents;
  }
}
