import 'package:flutterconf/schedule/schedule.dart';
import 'package:flutterconf/speakers/speakers.dart';

const mainStage = Location(
  name: 'Google Security Engineering Center Málaga',
  coordinates: (36.7183133, -4.4120845),
);

final talks = <Talk>[
  Talk(
    name: 'Aplicaciones agénticas con Gemini y Firebase',
    speakers: [speakers.firstWhere((s) => s.name == 'Alfredo Bautista')],
    duration: const Duration(minutes: 30),
    startTime: DateTime(2025, 10, 17, 9, 15),
    location: mainStage,
    description:
        'Ve más allá de los chatbots básicos y descubre el futuro de las aplicaciones inteligentes. Esta sesión se sumerge en el mundo de la IA agéntica, donde las aplicaciones no solo responden, sino que razonan, planifican y actúan. Aprenderás a usar los modelos Gemini de Google con el SDK de Firebase AI Logic para crear experiencias verdaderamente autónomas. Vete con el conocimiento para crear la próxima generación de aplicaciones inteligentes y agénticas que pueden realizar tareas complejas para tus usuarios.',
  ),
];
