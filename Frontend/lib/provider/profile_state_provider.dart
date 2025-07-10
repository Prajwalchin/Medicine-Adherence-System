import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class ProfileStateNotifier extends StateNotifier<ApiState> {
  ProfileStateNotifier() : super(ApiState.loading);

  setProfileState(ApiState apiState) {
    state = apiState;
  }
}

final profileStateProvider =
    StateNotifierProvider<ProfileStateNotifier, ApiState>((ref) {
  return ProfileStateNotifier();
});
