import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmobi/models/user_model.dart';

class ProfileNotifier extends StateNotifier<ProfileModel?> {
  ProfileNotifier() : super(null);

  setProfile(ProfileModel profile) {
    state = profile;
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileModel?>((ref) {
  return ProfileNotifier();
});
