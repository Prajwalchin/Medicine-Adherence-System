import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLoginStatusNotifier extends StateNotifier<String?> {
  UserLoginStatusNotifier() : super(null);

  setUserLoginStatus(String userStatus) {
    state = userStatus;
  }
}

final userLoginStatusProvider =
    StateNotifierProvider<UserLoginStatusNotifier, String?>((ref) {
  return UserLoginStatusNotifier();
});
