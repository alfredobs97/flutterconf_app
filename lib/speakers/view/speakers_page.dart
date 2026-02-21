import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/speakers/speakers.dart';
import 'package:flutterconf/theme/widgets/fc_app_bar.dart';

class SpeakersPage extends StatelessWidget {
  const SpeakersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeakersCubit()..loadSpeakers(),
      child: Scaffold(
        appBar: FCAppBar(),
        body: const SpeakersView(),
      ),
    );
  }
}

class SpeakersView extends StatelessWidget {
  const SpeakersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: _SearchBar(),
        ),
        Expanded(
          child: BlocBuilder<SpeakersCubit, SpeakersState>(
            builder: (context, state) {
              final filteredSpeakers = state.filteredSpeakers;

              if (filteredSpeakers.isEmpty) {
                return const Center(child: Text('No speakers found.'));
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredSpeakers.length,
                itemBuilder: (context, index) =>
                    SpeakerCard(speaker: filteredSpeakers[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) =>
                context.read<SpeakersCubit>().onSearchChanged(value),
            decoration: InputDecoration(
              hintText: 'Search by name or company',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        BlocBuilder<SpeakersCubit, SpeakersState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.sortOrder == SpeakerSortOrder.nameAsc
                    ? Icons.sort_by_alpha
                    : Icons.sort_by_alpha_outlined,
              ),
              onPressed: () {
                final newOrder = state.sortOrder == SpeakerSortOrder.nameAsc
                    ? SpeakerSortOrder.nameDesc
                    : SpeakerSortOrder.nameAsc;
                context.read<SpeakersCubit>().onSortOrderChanged(newOrder);
              },
              tooltip: state.sortOrder == SpeakerSortOrder.nameAsc
                  ? 'Sort Z-A'
                  : 'Sort A-Z',
            );
          },
        ),
      ],
    );
  }
}

extension on BuildContext {
  int get crossAxisCount {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) return 2;
    if (width < 800) return 3;
    return 4;
  }
}
