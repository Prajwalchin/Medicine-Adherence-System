import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmobi/models/todays_schedule_model.dart';

class TodaysScheduleNotifier extends StateNotifier<TodaysScheduleModel?> {
  TodaysScheduleNotifier() : super(null);

  setTodaysSchedule(TodaysScheduleModel todaysSchedule) {
    state = todaysSchedule;
  }
}

final todaysScheduleProvider =
    StateNotifierProvider<TodaysScheduleNotifier, TodaysScheduleModel?>((ref) {
  return TodaysScheduleNotifier();
});
