import 'package:equatable/equatable.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'schedule_state.dart';

class ScheduleCubit extends HydratedCubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState.day1);

  void toggleTab(int index) => emit(state.copyWith(index: index));

  void onSearchChanged(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) {
    return ScheduleState(
      index: json['index'] as int,
      searchQuery: json['searchQuery'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic>? toJson(ScheduleState state) => {
    'index': state.index,
    'searchQuery': state.searchQuery,
  };
}
