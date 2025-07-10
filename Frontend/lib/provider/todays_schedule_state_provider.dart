import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class TodaysScheduleStateNotifier extends StateNotifier<ApiState> {
  TodaysScheduleStateNotifier() : super(ApiState.loading);

  setTodaysScheduleState(ApiState todaysScheduleModel) {
    state = todaysScheduleModel;
  }
}

final todaysScheduleStateProvider =
    StateNotifierProvider<TodaysScheduleStateNotifier, ApiState>((ref) {
  return TodaysScheduleStateNotifier();
});
