import 'package:flutterconf/schedule/schedule.dart';

final allEvents = <Event>[...day1, ...day2];

final day1 = <Event>[
  ...talks,
  ...workshops,
  ...activities.where((a) => a.startTime.day == 10),
]..sort((a, b) => a.startTime.compareTo(b.startTime));

final day2 = <Event>[
  ...activities.where((a) => a.startTime.day == 11),
]..sort((a, b) => a.startTime.compareTo(b.startTime));
