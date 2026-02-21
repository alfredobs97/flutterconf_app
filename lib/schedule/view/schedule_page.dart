import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/location/location.dart';
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
        body: Column(
          children: [
            const _SearchBar(),
            Expanded(
              child: TabBarView(
                children: [
                  ScheduleListView(
                    events: state.filteredDay1,
                    venue: gsecMalaga,
                  ),
                  ScheduleListView(
                    events: state.filteredDay2,
                    venue: innovationCampus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) =>
            context.read<ScheduleCubit>().onSearchChanged(value),
        decoration: InputDecoration(
          hintText: 'Search by talk or speaker',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class ScheduleListView extends StatelessWidget {
  const ScheduleListView({required this.events, this.venue, super.key});

  final List<Event> events;
  final Location? venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (venue != null) VenueBanner(location: venue!),
        Expanded(
          child: events.isEmpty
              ? const Center(child: Text('No talks found.'))
              : ListView.separated(
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  padding: const EdgeInsets.all(12),
                  itemCount: events.length,
                  itemBuilder: (context, index) =>
                      EventCard(event: events[index]),
                ),
        ),
      ],
    );
  }
}
