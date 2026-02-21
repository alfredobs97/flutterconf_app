import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  group('ScheduleCubit', () {
    test('initial state is correct', () {
      expect(ScheduleCubit().state, ScheduleState.day1);
    });

    blocTest<ScheduleCubit, ScheduleState>(
      'toggleTab emits state with correct index',
      build: ScheduleCubit.new,
      act: (cubit) => cubit.toggleTab(1),
      expect: () => [
        const ScheduleState(index: 1),
      ],
    );

    blocTest<ScheduleCubit, ScheduleState>(
      'onSearchChanged emits state with correct query',
      build: ScheduleCubit.new,
      act: (cubit) => cubit.onSearchChanged('Flutter'),
      expect: () => [
        const ScheduleState(index: 0, searchQuery: 'Flutter'),
      ],
    );

    group('ScheduleState filtering', () {
      test('filteredDay1 returns all events when query is empty', () {
        const state = ScheduleState(index: 0);
        expect(state.filteredDay1.length, day1Events.length);
      });

      test(
        'filteredDay1 returns correct events for search query "Flutter"',
        () {
          const state = ScheduleState(index: 0, searchQuery: 'Flutter');
          final filtered = state.filteredDay1;
          // Matches "Charla 1: Flutter and AI" (name)
          // and "Taller - Live Coding" (speaker title contains Flutter)
          expect(filtered.length, 2);
          expect(
            filtered.any((e) => e.name.contains('Flutter and AI')),
            isTrue,
          );
          expect(
            filtered.any((e) => e.name.contains('Taller - Live Coding')),
            isTrue,
          );
        },
      );

      test('filteredDay1 returns correct events for speaker "Dash"', () {
        const state = ScheduleState(index: 0, searchQuery: 'Dash');
        final filtered = state.filteredDay1;
        // Matches "Charla 1: Flutter and AI" (speaker name)
        // and "Taller - Live Coding" (speaker name)
        expect(filtered.length, 2);
        expect(
          filtered.any((e) => e.name.contains('Flutter and AI')),
          isTrue,
        );
        expect(
          filtered.any((e) => e.name.contains('Taller - Live Coding')),
          isTrue,
        );
      });

      test('filteredDay1 returns empty list when no matches', () {
        const state = ScheduleState(index: 0, searchQuery: 'NonExistentTalk');
        expect(state.filteredDay1.isEmpty, isTrue);
      });
    });

    test('fromJson returns correct state', () {
      final cubit = ScheduleCubit();
      final state = cubit.fromJson({'index': 1, 'searchQuery': 'AI'});
      expect(state, const ScheduleState(index: 1, searchQuery: 'AI'));
    });

    test('toJson returns correct map', () {
      final cubit = ScheduleCubit();
      final map = cubit.toJson(
        const ScheduleState(index: 1, searchQuery: 'AI'),
      );
      expect(map, {'index': 1, 'searchQuery': 'AI'});
    });
  });
}
