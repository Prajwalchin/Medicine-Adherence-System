import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_analytics_model.dart';

class DashboardAnalyticsNotifier extends StateNotifier<DashboardAnalyticsModel?> {
  DashboardAnalyticsNotifier() : super(null);

  setDashboardAnalytics(DashboardAnalyticsModel dashboardAnalytics) {
    state = dashboardAnalytics;
  }
}

final dashboardAnalyticsProvider =
    StateNotifierProvider<DashboardAnalyticsNotifier, DashboardAnalyticsModel?>((ref) {
  return DashboardAnalyticsNotifier();
});
