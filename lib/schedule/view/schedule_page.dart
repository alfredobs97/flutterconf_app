import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:flutterconf/theme/theme.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(),
      child: const ScheduleView(),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScheduleCubit>().state;
    return DefaultTabController(
      initialIndex: state.index,
      length: ScheduleState.values.length,
      child: Scaffold(
        appBar: FFAppBar(
          bottom: TabBar(
            onTap: (index) => context.read<ScheduleCubit>().toggleTab(index),
            tabs: const <Widget>[
              Tab(child: Text('Day 1 Morning')),
              Tab(child: Text('Day 1 Evening')),
              Tab(child: Text('Day 2 Morning')),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ScheduleListView(
              events: allEvents
                  .where(
                    (e) => e.startTime.day == 17 && e.startTime.hour < 14,
                  )
                  .toList(),
            ),
            ScheduleListView(
              events: allEvents
                  .where(
                    (e) => e.startTime.day == 17 && e.startTime.hour >= 14,
                  )
                  .toList(),
            ),
            ScheduleListView(
              events: allEvents.where((e) => e.startTime.day == 18).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleListView extends StatelessWidget {
  const ScheduleListView({required this.events, super.key});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      padding: const EdgeInsets.all(12),
      itemCount: events.length,
      itemBuilder: (context, index) => EventCard(event: events[index]),
    );
  }
}
