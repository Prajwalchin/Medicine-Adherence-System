import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class DashboardAnalyticsStateNotifier extends StateNotifier<ApiState> {
  DashboardAnalyticsStateNotifier() : super(ApiState.loading);

  setDashboardAnalyticsState(ApiState dashboardAnalyticsState) {
    state = dashboardAnalyticsState;
  }
}

final dashboardAnalyticsStateProvider =
    StateNotifierProvider<DashboardAnalyticsStateNotifier, ApiState>((ref) {
  return DashboardAnalyticsStateNotifier();
});
