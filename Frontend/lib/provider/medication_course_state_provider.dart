import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class MedicationCourseStateNotifier extends StateNotifier<ApiState> {
  MedicationCourseStateNotifier() : super(ApiState.loading);

  setMedicationCourseState(ApiState medicationCourseState) {
    state = medicationCourseState;
  }
}

final medicationCourseStateProvider =
    StateNotifierProvider<MedicationCourseStateNotifier, ApiState>((ref) {
  return MedicationCourseStateNotifier();
});
