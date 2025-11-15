import 'package:equatable/equatable.dart';
import 'package:flutterconf/schedule/schedule.dart';

class Schedule extends Equatable {
  const Schedule({required this.events});

  final List<Event> events;

  @override
  List<Object> get props => [events];
}
