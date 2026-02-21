import 'package:flutterconf/schedule/schedule.dart';

final allEvents = <Event>[...day1Events, ...day2Events];

final day1Events = <Event>[
  ...talks,
  ...workshops,
  ...activities.where((a) => a.startTime.day == 10),
]..sort((a, b) => a.startTime.compareTo(b.startTime));

final day2Events = <Event>[
  ...activities.where((a) => a.startTime.day == 11),
]..sort((a, b) => a.startTime.compareTo(b.startTime));
