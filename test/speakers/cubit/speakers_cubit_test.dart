import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/speakers/speakers.dart';

void main() {
  group('SpeakersCubit', () {
    test('initial state is correct', () {
      expect(SpeakersCubit().state, const SpeakersState());
    });

    blocTest<SpeakersCubit, SpeakersState>(
      'loadSpeakers emits state with all speakers',
      build: SpeakersCubit.new,
      act: (cubit) => cubit.loadSpeakers(),
      expect: () => [
        const SpeakersState(speakers: speakers),
      ],
    );

    blocTest<SpeakersCubit, SpeakersState>(
      'onSearchChanged updates query',
      build: SpeakersCubit.new,
      act: (cubit) => cubit.onSearchChanged('Dash'),
      expect: () => [
        const SpeakersState(query: 'Dash'),
      ],
    );

    blocTest<SpeakersCubit, SpeakersState>(
      'onSortOrderChanged updates sortOrder',
      build: SpeakersCubit.new,
      act: (cubit) => cubit.onSortOrderChanged(SpeakerSortOrder.nameDesc),
      expect: () => [
        const SpeakersState(sortOrder: SpeakerSortOrder.nameDesc),
      ],
    );

    group('SpeakersState getters', () {
      const testSpeakers = [
        Speaker(name: 'Alice', title: 'Developer', bio: 'Bio A', avatar: 'a'),
        Speaker(name: 'Bob', title: 'Manager', bio: 'Bio B', avatar: 'b'),
        Speaker(name: 'Charlie', title: 'Designer', bio: 'Bio C', avatar: 'c'),
        Speaker(name: 'David', title: 'Developer', bio: 'Bio D', avatar: 'd'),
        Speaker(name: 'Eve', title: 'Tester', bio: 'Bio E', avatar: 'e'),
      ];

      test('filteredSpeakers filters by name correctly', () {
        const state = SpeakersState(speakers: testSpeakers, query: 'Alice');
        expect(state.filteredSpeakers, [testSpeakers[0]]);
      });

      test('filteredSpeakers filters by company/title correctly', () {
        const state = SpeakersState(speakers: testSpeakers, query: 'Developer');
        expect(state.filteredSpeakers, [testSpeakers[0], testSpeakers[3]]);
      });

      test('filteredSpeakers sorts by nameAsc correctly', () {
        const state = SpeakersState(
          speakers: testSpeakers,
        );
        expect(state.filteredSpeakers.first.name, 'Alice');
        expect(state.filteredSpeakers.last.name, 'Eve');
      });

      test('filteredSpeakers sorts by nameDesc correctly', () {
        const state = SpeakersState(
          speakers: testSpeakers,
          sortOrder: SpeakerSortOrder.nameDesc,
        );
        expect(state.filteredSpeakers.first.name, 'Eve');
        expect(state.filteredSpeakers.last.name, 'Alice');
      });
    });
  });
}
