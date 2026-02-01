import 'package:flutterconf/schedule/schedule.dart';

final allEvents = <Event>[...day1, ...day2];

final day1 = <Event>[
  Activity(
    name: 'Bienvenida y networking',
    duration: const Duration(minutes: 30),
    startTime: DateTime(2025, 10, 17, 8, 30),
    location: mainStage,
  ),
  Talk(
    name: 'Opening',
    speakers: const [],
    duration: const Duration(minutes: 15),
    startTime: DateTime(2025, 10, 17, 9, 0),
    location: mainStage,
    description: 'Conoce FlutterConf y empieza con nosotros el evento',
  ),
  ...talks.where((t) => t.startTime.day == 17),
  Activity(
    name: 'Coffee Break',
    duration: const Duration(minutes: 30),
    startTime: DateTime(2025, 10, 17, 10, 45),
    location: mainStage,
  ),
  Talk(
    name: 'Closing',
    speakers: const [],
    duration: const Duration(minutes: 15),
    startTime: DateTime(2025, 10, 17, 13, 45),
    location: mainStage,
    description:
        'Despedimos la primera parte de la FlutterConf con sorteos y sorpresas',
  ),
  Activity(
    name: 'Networking',
    duration: const Duration(minutes: 60),
    startTime: DateTime(2025, 10, 17, 14, 0),
    location: mainStage,
  ),
  Activity(
    name: 'Bienvenida parte 2',
    duration: const Duration(minutes: 15),
    startTime: DateTime(2025, 10, 17, 16, 15),
    location: mainStage,
  ),
  Activity(
    name: 'Mesa de comunidades',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2025, 10, 17, 16, 30),
    location: mainStage,
    description:
        'Diferentes comunidades de Flutter participarán para dar su visión',
  ),
  Activity(
    name: 'Dart Conversations',
    duration: const Duration(minutes: 45),
    startTime: DateTime(2025, 10, 17, 17, 15),
    location: mainStage,
    description:
        'Nuestro Podcast donde comentaremos todo lo vivido en la FlutterConf',
  ),
  Activity(
    name: 'Networking con Cervezas Victoria',
    duration: const Duration(minutes: 60),
    startTime: DateTime(2025, 10, 17, 18, 0),
    location: mainStage,
    description:
        'Acompáñanos a cerrar el evento con la colaboración malagueña de Cervezas Victoria',
  ),
];

final day2 = <Event>[
  Activity(
    name: 'Café-networking',
    duration: const Duration(minutes: 60),
    startTime: DateTime(2025, 10, 18, 10, 30),
    location: mainStage,
  ),
  Talk(
    name: 'Presentación de comunidades',
    speakers: const [],
    duration: const Duration(minutes: 45),
    startTime: DateTime(2025, 10, 18, 11, 30),
    location: mainStage,
    description: 'Presentación de las diferentes comunidades de Flutter.',
  ),
  Talk(
    name: 'Lightning talks sobre temas Dart y Flutter',
    speakers: const [],
    duration: const Duration(minutes: 45),
    startTime: DateTime(2025, 10, 18, 12, 15),
    location: mainStage,
    description: 'Charlas rápidas sobre diversos temas de Dart y Flutter.',
  ),
  Talk(
    name: 'Cierre evento',
    speakers: const [],
    duration: const Duration(minutes: 15),
    startTime: DateTime(2025, 10, 18, 13, 0),
    location: mainStage,
    description: 'Despedida y cierre del evento.',
  ),
];
