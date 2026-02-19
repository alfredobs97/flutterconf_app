import 'package:flutterconf/schedule/schedule.dart';

final activities = <Activity>[
  Activity(
    name: 'Bienvenida y networking',
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 9),
    location: mainStage,
    description: 'Welcome and networking session.',
  ),
  Activity(
    name: 'Opening',
    duration: const Duration(minutes: 15),
    startTime: DateTime(2026, 4, 10, 9, 30),
    location: mainStage,
    description: 'Conference opening remarks.',
  ),
  Activity(
    name: 'Coffe break',
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 10, 11, 15),
    location: mainStage,
  ),
  Activity(
    name: 'Cierre',
    duration: const Duration(minutes: 5),
    startTime: DateTime(2026, 4, 10, 12, 45),
    location: mainStage,
  ),
  Activity(
    name: 'Networking',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2026, 4, 10, 12, 50),
    location: mainStage,
  ),
  Activity(
    name: 'Org y voluntarios vamos a comer',
    duration: const Duration(hours: 1),
    startTime: DateTime(2026, 4, 10, 13, 45),
    location: mainStage,
  ),
  Activity(
    name: 'Bienvenida y networking (Tarde)',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2026, 4, 10, 14, 45),
    location: mainStage,
  ),
  Activity(
    name: 'Opening (Tarde)',
    duration: const Duration(minutes: 15),
    startTime: DateTime(2026, 4, 10, 15, 30),
    location: mainStage,
  ),
  Activity(
    name: 'Break y networking',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2026, 4, 10, 17, 15),
    location: mainStage,
  ),
  Activity(
    name: 'Cierre (Tarde)',
    duration: const Duration(minutes: 10),
    startTime: DateTime(2026, 4, 10, 19, 30),
    location: mainStage,
  ),
  Activity(
    name: 'Networking final',
    duration: const Duration(minutes: 80),
    startTime: DateTime(2026, 4, 10, 19, 40),
    location: mainStage,
  ),
  // Day 2
  Activity(
    name: 'Bienvenida con café y networking',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2026, 4, 11, 10, 15),
    location: mainStage,
  ),
  Activity(
    name: 'Presentación de comunidades',
    duration: const Duration(minutes: 30),
    startTime: DateTime(2026, 4, 11, 11),
    location: mainStage,
    description: 'Las diferentes comunidades se presentan.',
  ),
  Activity(
    name: 'Mesa redonda de todas las comunidades',
    duration: const Duration(hours: 1),
    startTime: DateTime(2026, 4, 11, 11, 30),
    location: mainStage,
    description: 'De los topics de la presentación, se debaten.',
  ),
  Activity(
    name: 'Planes a futuro y colaboraciones',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2026, 4, 11, 12, 30),
    location: mainStage,
    description: 'Después de discutir y encontrar a lo mejor...',
  ),
  Activity(
    name: 'Cierre y despedida',
    duration: const Duration(minutes: 15),
    startTime: DateTime(2026, 4, 11, 13, 15),
    location: mainStage,
  ),
];
