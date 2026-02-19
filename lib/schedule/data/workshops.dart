import 'package:flutterconf/schedule/schedule.dart';
import 'package:flutterconf/speakers/data/data.dart';

const aiTrack = Location(
  name: 'AI Track',
  coordinates: (59.3308268, 18.0633923),
);

const dashTrack = Location(
  name: 'Dash Track',
  coordinates: (59.3308268, 18.0633923),
);

final workshops = <Workshop>[
  Workshop(
    name: 'Taller - Live Coding',
    speakers: [speakers[0], speakers[3]],
    duration: const Duration(hours: 1),
    startTime: DateTime(2026, 4, 10, 11, 45),
    description: 'Hands-on coding session with Dash and Alan Turing.',
    location: dashTrack,
  ),
];
