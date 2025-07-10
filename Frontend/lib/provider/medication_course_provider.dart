import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medication_course_model.dart';

class MedicationCourseNotifier extends StateNotifier<MedicationCourseModel?> {
  MedicationCourseNotifier() : super(null);

  setMedicationCourse(MedicationCourseModel medicationCourse) {
    state = medicationCourse;
  }
}

final medicationCourseProvider =
    StateNotifierProvider<MedicationCourseNotifier, MedicationCourseModel?>((ref) {
  return MedicationCourseNotifier();
});
