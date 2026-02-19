import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:flutterconf/theme/widgets/fc_app_bar.dart';

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
      length: 2,
      child: Scaffold(
        appBar: FCAppBar(
          bottom: TabBar(
            onTap: (index) => context.read<ScheduleCubit>().toggleTab(index),
            tabs: const <Widget>[
              Tab(child: Text('Day 1')),
              Tab(child: Text('Day 2')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ScheduleListView(events: day1),
            ScheduleListView(events: day2),
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
