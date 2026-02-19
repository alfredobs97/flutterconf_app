import 'package:flutterconf/schedule/schedule.dart';
import 'package:flutterconf/speakers/data/data.dart';

const mainStage = Location(
  name: 'Main Stage',
  coordinates: (59.332042, 18.0649439),
);

final talks = <Talk>[
  Talk(
    name: 'Charla 1: Flutter and AI',
    speakers: [speakers[0], speakers[1]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 9, 45),
    location: mainStage,
    description: 'Exploring the intersection of Flutter and AI.',
  ),
  Talk(
    name: 'Charla 2: State Management in 2026',
    speakers: [speakers[2]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 10, 15),
    location: mainStage,
    description: 'A deep dive into modern state management patterns.',
  ),
  Talk(
    name: 'Charla 3: Declarative Graphics',
    speakers: [speakers[9]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 10, 45),
    location: mainStage,
    description: 'High-performance rendering with Flutter.',
  ),
  Talk(
    name: 'Charla 4: Backend for Frontend',
    speakers: [speakers[6]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 18),
    location: mainStage,
    description: 'Scaling your Flutter app with efficient APIs.',
  ),
  Talk(
    name: 'Charla 5: Testing at Scale',
    speakers: [speakers[5]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 18, 30),
    location: mainStage,
    description: 'Ensuring reliability in complex Flutter codebases.',
  ),
  Talk(
    name: 'Charla 6: The Future of Dart',
    speakers: [speakers[7], speakers[8]],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 19),
    location: mainStage,
    description: 'What is next for the language we love.',
  ),
];
